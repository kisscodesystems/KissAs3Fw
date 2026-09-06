#!/usr/bin/env python3

"""Converts the emoji SVG files of a resource folder into one KVG1 blob.

This is a part of the KissAs3Fw ActionScript framework.
See the header comment lines of the com.kisscodesystems.KissAs3Fw.Application

The emojis are vector drawings, but ActionScript cannot display an SVG: neither
the [Embed] metadata nor the runtime knows that format. So the SVGs are the
source of truth in the repository, and this script flattens every one of them,
at build time, into the compact drawing commands the flash.display.Graphics of
the runtime consumes directly. The whole hard part of SVG - the transforms, the
elliptical arcs, the shorthand path commands, the presentation attributes - is
resolved here, once, where it is easy to fix, so the ActionScript side stays a
few dozen lines of ByteArray reading. See EmojiManager.getNewBitmapData and
com.kisscodesystems.KissAs3Fw.util.VectorDrawing for the consuming end.

It is called by the generate_classes scripts of the resource folders, and it can
be called by hand as well:

  ./svg_to_kvg.py emoji/ emoji/emojis.kvg

The KVG1 container, little endian throughout. Coordinates are signed 16 bit
fixed point numbers in 1/UNIT of a viewBox unit, and every drawing is normalized
into a 0..32 box, so the numbers stay well inside the 16 bit range and keep
about a hundredth of a pixel of precision even when an emoji is blown up to
512 pixels:

  "KVG1"                     magic
  uint16   drawingCount
  drawingCount times:        the index, so a name can be looked up without
    uint8  nameLength        walking the drawings themselves
    utf8   name
    uint32 offset            from the start of the file
  drawingCount times:        the drawings, in index order
    uint16 shapeCount
    shapeCount times:
      uint32 argb            the fill colour, alpha in the high byte, a zero
                             alpha meaning the shape is outlined only
      uint8  flags           bit 0 set: the winding rule is even-odd
                             bit 1 set: the three stroke fields below follow
      uint32 strokeArgb      only when bit 1 of the flags is set
      uint16 strokeWidth     only then, in 1/UNIT of a unit
      uint8  strokeCaps      only then: 0 none, 1 round, 2 square
      uint16 commandCount
      commandCount times:
        uint8                a flash.display.GraphicsPathCommand value:
                             1 moveTo, 2 lineTo, 6 cubicCurveTo
      int16 pairs            the coordinates the commands consume, in order:
                             one pair for a moveTo and a lineTo, three for a
                             cubicCurveTo
"""

import math
import os
import re
import struct
import sys

# The coordinate space every drawing is normalized into, and the fixed point
# divisor of the stored coordinates.
BOX = 32.0
UNIT = 64

# The flash.display.GraphicsPathCommand values this converter emits. Everything
# an SVG can express is reduced to these three: an elliptical arc, a quadratic
# curve and every shorthand form is rewritten into cubic curves and lines.
MOVE_TO = 1
LINE_TO = 2
CUBIC_CURVE_TO = 6

# The flash.display.CapsStyle values, as the stroke-linecap of an SVG names them.
CAPS = {"butt": 0, "round": 1, "square": 2}

# The only named colours the emoji sets use. Anything else is a hex triplet.
NAMED_COLOURS = {
    "none": None,
    "black": 0x000000,
    "white": 0xFFFFFF,
    "red": 0xFF0000,
    "green": 0x008000,
    "blue": 0x0000FF,
    "yellow": 0xFFFF00,
    "gray": 0x808080,
    "grey": 0x808080,
    "silver": 0xC0C0C0,
    "orange": 0xFFA500,
    "purple": 0x800080,
    "brown": 0xA52A2A,
    "pink": 0xFFC0CB,
}

NUMBER = re.compile(r"[-+]?(?:\d*\.\d+|\d+\.?)(?:[eE][-+]?\d+)?")
TOKEN = re.compile(r"[MmZzLlHhVvCcSsQqTtAa]|" + NUMBER.pattern)


class ConversionError(Exception):
    """Raised when an SVG uses something this converter cannot express."""


# ---------------------------------------------------------------------------
# the tiny XML reader
#
# The emoji SVGs are machine generated and flat: a handful of element kinds, no
# entities, no namespaces to speak of, no CDATA. A regex reader is enough for
# them and keeps this script free of any dependency, but it does mean an SVG
# hand-written in a full-featured editor may need a look before it is dropped
# into the resource folder.
# ---------------------------------------------------------------------------

ELEMENT = re.compile(r"<(/?)([A-Za-z][\w:.-]*)((?:\s+[\w:.-]+\s*=\s*(?:\"[^\"]*\"|'[^']*'))*)\s*(/?)>")
ATTRIBUTE = re.compile(r"([\w:.-]+)\s*=\s*(?:\"([^\"]*)\"|'([^']*)')")


class Element(object):
    """One SVG element with its attributes and its children."""

    def __init__(self, name, attributes):
        self.name = name
        self.attributes = attributes
        self.children = []


def parse_xml(text):
    """Builds the element tree of the given SVG document."""
    text = re.sub(r"<\?.*?\?>|<!--.*?-->|<!\[CDATA\[.*?\]\]>|<!DOCTYPE[^>]*>", "", text, flags=re.S)
    root = None
    stack = []
    for match in ELEMENT.finditer(text):
        closing, name, attribute_text, empty = match.groups()
        if closing:
            if stack:
                stack.pop()
            continue
        attributes = {}
        for found in ATTRIBUTE.finditer(attribute_text):
            key, quoted, single = found.groups()
            attributes[key] = quoted if quoted else single
        element = Element(name, attributes)
        if stack:
            stack[-1].children.append(element)
        elif root is None:
            root = element
        if not empty:
            stack.append(element)
    if root is None:
        raise ConversionError("no root element")
    return root


# ---------------------------------------------------------------------------
# transforms
# ---------------------------------------------------------------------------

def multiply(outer, inner):
    """Concatenates two [a, b, c, d, e, f] affine matrices."""
    a1, b1, c1, d1, e1, f1 = outer
    a2, b2, c2, d2, e2, f2 = inner
    return [
        a1 * a2 + c1 * b2,
        b1 * a2 + d1 * b2,
        a1 * c2 + c1 * d2,
        b1 * c2 + d1 * d2,
        a1 * e2 + c1 * f2 + e1,
        b1 * e2 + d1 * f2 + f1,
    ]


def parse_transform(text):
    """Turns an SVG transform attribute into a single affine matrix."""
    matrix = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
    for name, arguments in re.findall(r"([a-zA-Z]+)\s*\(([^)]*)\)", text or ""):
        values = [float(v) for v in NUMBER.findall(arguments)]
        if name == "matrix" and len(values) == 6:
            step = values
        elif name == "translate":
            step = [1.0, 0.0, 0.0, 1.0, values[0], values[1] if len(values) > 1 else 0.0]
        elif name == "scale":
            sx = values[0]
            sy = values[1] if len(values) > 1 else sx
            step = [sx, 0.0, 0.0, sy, 0.0, 0.0]
        elif name == "rotate":
            angle = math.radians(values[0])
            cos, sin = math.cos(angle), math.sin(angle)
            step = [cos, sin, -sin, cos, 0.0, 0.0]
            if len(values) == 3:
                cx, cy = values[1], values[2]
                step = multiply([1.0, 0.0, 0.0, 1.0, cx, cy], multiply(step, [1.0, 0.0, 0.0, 1.0, -cx, -cy]))
        elif name in ("skewX", "skewY"):
            tangent = math.tan(math.radians(values[0]))
            step = [1.0, 0.0, tangent, 1.0, 0.0, 0.0] if name == "skewX" else [1.0, tangent, 0.0, 1.0, 0.0, 0.0]
        else:
            raise ConversionError("unknown transform %s" % name)
        matrix = multiply(matrix, step)
    return matrix


def apply_matrix(matrix, x, y):
    """Maps one point through an affine matrix."""
    a, b, c, d, e, f = matrix
    return a * x + c * y + e, b * x + d * y + f


# ---------------------------------------------------------------------------
# path data
# ---------------------------------------------------------------------------

def arc_to_cubics(x0, y0, rx, ry, rotation, large_arc, sweep, x, y):
    """Rewrites one SVG elliptical arc as a list of cubic curve segments.

    The endpoint parameterization of the SVG specification, turned into the
    centre parameterization, then split into segments of at most a quarter turn
    because that is the widest sweep a cubic approximates well.
    """
    if rx == 0 or ry == 0 or (x0 == x and y0 == y):
        return [(x, y, x, y, x, y)]
    rx, ry = abs(rx), abs(ry)
    angle = math.radians(rotation)
    cos, sin = math.cos(angle), math.sin(angle)
    # into the untilted, unit-radius space
    dx2, dy2 = (x0 - x) / 2.0, (y0 - y) / 2.0
    x1 = cos * dx2 + sin * dy2
    y1 = -sin * dx2 + cos * dy2
    # grow the radii when they cannot span the two endpoints
    oversize = (x1 * x1) / (rx * rx) + (y1 * y1) / (ry * ry)
    if oversize > 1:
        rx *= math.sqrt(oversize)
        ry *= math.sqrt(oversize)
    denominator = rx * rx * y1 * y1 + ry * ry * x1 * x1
    numerator = max(rx * rx * ry * ry - denominator, 0.0)
    factor = math.sqrt(numerator / denominator) if denominator else 0.0
    if large_arc == sweep:
        factor = -factor
    cx1 = factor * rx * y1 / ry
    cy1 = -factor * ry * x1 / rx
    cx = cos * cx1 - sin * cy1 + (x0 + x) / 2.0
    cy = sin * cx1 + cos * cy1 + (y0 + y) / 2.0

    def angle_of(ux, uy):
        return math.atan2(uy, ux)

    start = angle_of((x1 - cx1) / rx, (y1 - cy1) / ry)
    end = angle_of((-x1 - cx1) / rx, (-y1 - cy1) / ry)
    sweep_angle = end - start
    if sweep and sweep_angle < 0:
        sweep_angle += 2 * math.pi
    elif not sweep and sweep_angle > 0:
        sweep_angle -= 2 * math.pi

    segments = max(1, int(math.ceil(abs(sweep_angle) / (math.pi / 2) - 1e-9)))
    step = sweep_angle / segments
    # the classic cubic handle length for a circular sweep of "step" radians
    handle = 4.0 / 3.0 * math.tan(step / 4.0)
    result = []
    theta = start
    for _ in range(segments):
        next_theta = theta + step
        cos1, sin1 = math.cos(theta), math.sin(theta)
        cos2, sin2 = math.cos(next_theta), math.sin(next_theta)

        def place(ux, uy):
            return (cos * rx * ux - sin * ry * uy + cx, sin * rx * ux + cos * ry * uy + cy)

        p1 = place(cos1, sin1)
        p2 = place(cos2, sin2)
        c1 = place(cos1 - handle * sin1, sin1 + handle * cos1)
        c2 = place(cos2 + handle * sin2, sin2 - handle * cos2)
        result.append((c1[0], c1[1], c2[0], c2[1], p2[0], p2[1]))
        theta = next_theta
    if result:
        last = list(result[-1])
        last[4], last[5] = x, y
        result[-1] = tuple(last)
    return result


def parse_path(data):
    """Turns an SVG path data string into (commands, points) lists.

    The commands are the GraphicsPathCommand values, the points are the flat
    x, y coordinates they consume. Everything is absolute by then, and every
    curve is a cubic.
    """
    tokens = TOKEN.findall(data or "")
    commands = []
    points = []
    index = 0
    x = y = 0.0
    start_x = start_y = 0.0
    # the reflection of the previous curve's second control point, for S and T
    last_control = None
    last_kind = None
    command = None

    def number():
        nonlocal index
        value = float(tokens[index])
        index += 1
        return value

    def emit_move(nx, ny):
        commands.append(MOVE_TO)
        points.extend((nx, ny))

    def emit_line(nx, ny):
        commands.append(LINE_TO)
        points.extend((nx, ny))

    def emit_cubic(c1x, c1y, c2x, c2y, nx, ny):
        commands.append(CUBIC_CURVE_TO)
        points.extend((c1x, c1y, c2x, c2y, nx, ny))

    started = False
    while index < len(tokens):
        token = tokens[index]
        if token.isalpha():
            command = token
            index += 1
            if command in "Zz":
                # An implicit close: the fill closes every subpath anyway, so
                # nothing is emitted, only the current point moves back.
                x, y = start_x, start_y
                last_control = None
                last_kind = None
                continue
        elif command is None:
            raise ConversionError("path data starts with a number")
        elif command in "Mm":
            # A repeated M behaves as an L, per the specification.
            command = "L" if command == "M" else "l"

        relative = command.islower()
        kind = command.upper()
        if kind == "M":
            nx, ny = number(), number()
            if relative:
                nx, ny = x + nx, y + ny
            emit_move(nx, ny)
            x, y = nx, ny
            start_x, start_y = nx, ny
            started = True
            last_control = None
        else:
            if not started:
                # A path that draws before it moves starts at the origin.
                emit_move(x, y)
                start_x, start_y = x, y
                started = True
            if kind == "L":
                nx, ny = number(), number()
                if relative:
                    nx, ny = x + nx, y + ny
                emit_line(nx, ny)
                x, y = nx, ny
                last_control = None
            elif kind == "H":
                nx = number()
                nx = x + nx if relative else nx
                emit_line(nx, y)
                x = nx
                last_control = None
            elif kind == "V":
                ny = number()
                ny = y + ny if relative else ny
                emit_line(x, ny)
                y = ny
                last_control = None
            elif kind == "C":
                c1x, c1y, c2x, c2y, nx, ny = (number() for _ in range(6))
                if relative:
                    c1x, c1y = x + c1x, y + c1y
                    c2x, c2y = x + c2x, y + c2y
                    nx, ny = x + nx, y + ny
                emit_cubic(c1x, c1y, c2x, c2y, nx, ny)
                x, y = nx, ny
                last_control = (c2x, c2y)
            elif kind == "S":
                c2x, c2y, nx, ny = (number() for _ in range(4))
                if relative:
                    c2x, c2y = x + c2x, y + c2y
                    nx, ny = x + nx, y + ny
                if last_control is not None and last_kind in ("C", "S"):
                    c1x, c1y = 2 * x - last_control[0], 2 * y - last_control[1]
                else:
                    c1x, c1y = x, y
                emit_cubic(c1x, c1y, c2x, c2y, nx, ny)
                x, y = nx, ny
                last_control = (c2x, c2y)
            elif kind in ("Q", "T"):
                if kind == "Q":
                    qx, qy, nx, ny = (number() for _ in range(4))
                    if relative:
                        qx, qy = x + qx, y + qy
                        nx, ny = x + nx, y + ny
                else:
                    nx, ny = number(), number()
                    if relative:
                        nx, ny = x + nx, y + ny
                    if last_control is not None and last_kind in ("Q", "T"):
                        qx, qy = 2 * x - last_control[0], 2 * y - last_control[1]
                    else:
                        qx, qy = x, y
                # a quadratic is exactly this cubic
                emit_cubic(
                    x + 2.0 / 3.0 * (qx - x), y + 2.0 / 3.0 * (qy - y),
                    nx + 2.0 / 3.0 * (qx - nx), ny + 2.0 / 3.0 * (qy - ny),
                    nx, ny)
                x, y = nx, ny
                last_control = (qx, qy)
            elif kind == "A":
                rx, ry, rotation = number(), number(), number()
                large_arc, sweep = number(), number()
                nx, ny = number(), number()
                if relative:
                    nx, ny = x + nx, y + ny
                for segment in arc_to_cubics(x, y, rx, ry, rotation, large_arc != 0, sweep != 0, nx, ny):
                    emit_cubic(*segment)
                x, y = nx, ny
                last_control = None
            else:
                raise ConversionError("unknown path command %s" % command)
        last_kind = kind
    return commands, points


# ---------------------------------------------------------------------------
# the shape elements
# ---------------------------------------------------------------------------

def length_of(element, name, default=0.0):
    """Reads one numeric attribute, ignoring any unit suffix."""
    text = element.attributes.get(name)
    if text is None:
        return default
    found = NUMBER.match(text.strip())
    return float(found.group(0)) if found else default


def rounded_rectangle(x, y, width, height, rx, ry):
    """Builds the path of a rectangle, rounded corners included."""
    rx = min(rx, width / 2.0)
    ry = min(ry, height / 2.0)
    if rx <= 0 or ry <= 0:
        return (
            [MOVE_TO, LINE_TO, LINE_TO, LINE_TO],
            [x, y, x + width, y, x + width, y + height, x, y + height])
    return parse_path(
        "M%f %f H%f A%f %f 0 0 1 %f %f V%f A%f %f 0 0 1 %f %f H%f A%f %f 0 0 1 %f %f V%f A%f %f 0 0 1 %f %f Z" % (
            x + rx, y, x + width - rx,
            rx, ry, x + width, y + ry,
            y + height - ry,
            rx, ry, x + width - rx, y + height,
            x + rx,
            rx, ry, x, y + height - ry,
            y + ry,
            rx, ry, x + rx, y))


def ellipse_path(cx, cy, rx, ry):
    """Builds the path of a circle or an ellipse out of four arcs."""
    return parse_path("M%f %f A%f %f 0 0 1 %f %f A%f %f 0 0 1 %f %f Z" % (
        cx - rx, cy, rx, ry, cx + rx, cy, rx, ry, cx - rx, cy))


def geometry_of(element):
    """Returns the (commands, points) of one drawable element, or None."""
    if element.name == "path":
        return parse_path(element.attributes.get("d", ""))
    if element.name == "rect":
        rx = length_of(element, "rx", -1.0)
        ry = length_of(element, "ry", -1.0)
        if rx < 0:
            rx = max(ry, 0.0)
        if ry < 0:
            ry = max(rx, 0.0)
        return rounded_rectangle(
            length_of(element, "x"), length_of(element, "y"),
            length_of(element, "width"), length_of(element, "height"), rx, ry)
    if element.name == "circle":
        radius = length_of(element, "r")
        return ellipse_path(length_of(element, "cx"), length_of(element, "cy"), radius, radius)
    if element.name == "ellipse":
        return ellipse_path(
            length_of(element, "cx"), length_of(element, "cy"),
            length_of(element, "rx"), length_of(element, "ry"))
    if element.name in ("polygon", "polyline"):
        values = [float(v) for v in NUMBER.findall(element.attributes.get("points", ""))]
        if len(values) < 4:
            return None
        commands = [MOVE_TO] + [LINE_TO] * (len(values) // 2 - 1)
        return commands, values[:len(commands) * 2]
    if element.name == "line":
        return ([MOVE_TO, LINE_TO], [
            length_of(element, "x1"), length_of(element, "y1"),
            length_of(element, "x2"), length_of(element, "y2")])
    return None


# ---------------------------------------------------------------------------
# paint
# ---------------------------------------------------------------------------

def parse_colour(text):
    """Turns a fill value into a 0xRRGGBB integer, or None when it paints nothing."""
    text = (text or "").strip()
    if not text:
        return 0x000000
    lowered = text.lower()
    if lowered in NAMED_COLOURS:
        return NAMED_COLOURS[lowered]
    if lowered.startswith("#"):
        digits = lowered[1:]
        if len(digits) == 3:
            return int(digits[0] * 2 + digits[1] * 2 + digits[2] * 2, 16)
        if len(digits) in (6, 8):
            return int(digits[:6], 16)
        return None
    match = re.match(r"rgba?\(([^)]*)\)", lowered)
    if match:
        parts = [p.strip() for p in match.group(1).replace("/", ",").split(",")]
        channels = []
        for part in parts[:3]:
            value = float(NUMBER.match(part).group(0))
            channels.append(int(round(value * 255 / 100.0 if part.endswith("%") else value)))
        return (channels[0] << 16) | (channels[1] << 8) | channels[2]
    if lowered.startswith("url("):
        return "reference:" + lowered[4:].rstrip(")").strip("'\"").lstrip("#")
    return None


def average_gradient_colour(gradient):
    """Collapses a gradient into the single colour that stands in for it.

    ActionScript can draw a gradient, but only two of the nine hundred emojis
    hold one, and both use it for a subtle shade on a body that reads the same
    at any size the framework displays. A flat mean of the stops, weighted by
    how much of the ramp each one covers, keeps the format and the runtime free
    of a case that earns nothing.
    """
    stops = []
    for child in gradient.children:
        if child.name != "stop":
            continue
        colour = parse_colour(child.attributes.get("stop-color", "#000000"))
        if not isinstance(colour, int):
            continue
        offset_text = child.attributes.get("offset", "0")
        offset = float(NUMBER.match(offset_text.strip()).group(0))
        if offset_text.strip().endswith("%"):
            offset /= 100.0
        alpha = float(child.attributes.get("stop-opacity", "1"))
        stops.append((offset, colour, alpha))
    if not stops:
        return None, 1.0
    stops.sort(key=lambda s: s[0])
    if len(stops) == 1:
        return stops[0][1], stops[0][2]
    red = green = blue = alpha = weight_total = 0.0
    for index, (offset, colour, stop_alpha) in enumerate(stops):
        before = stops[index - 1][0] if index else offset
        after = stops[index + 1][0] if index + 1 < len(stops) else offset
        weight = max((after - before) / 2.0, 1e-6)
        red += ((colour >> 16) & 0xFF) * weight
        green += ((colour >> 8) & 0xFF) * weight
        blue += (colour & 0xFF) * weight
        alpha += stop_alpha * weight
        weight_total += weight
    return (
        (int(round(red / weight_total)) << 16)
        | (int(round(green / weight_total)) << 8)
        | int(round(blue / weight_total)),
        alpha / weight_total)


# ---------------------------------------------------------------------------
# the document walk
# ---------------------------------------------------------------------------

class Shape(object):
    """One flat shape: its colours, its winding rule and its geometry."""

    def __init__(self, argb, even_odd, commands, points,
                 stroke_argb=0, stroke_width=0.0, stroke_caps=1):
        self.argb = argb
        self.stroke_argb = stroke_argb
        self.stroke_width = stroke_width
        self.stroke_caps = stroke_caps
        self.even_odd = even_odd
        self.commands = commands
        self.points = points


def paint_of(state, property_name, default, definitions, warnings, name):
    """Resolves one paint property into an ARGB value, or 0 when it paints nothing.

    Handles the gradient references as well: those are flattened to the single
    colour that stands in for them.
    """
    text = state.get(property_name, default)
    if text is None:
        return 0
    colour = parse_colour(text)
    alpha = 1.0
    if isinstance(colour, str) and colour.startswith("reference:"):
        gradient = definitions.get(colour[len("reference:"):])
        if gradient is None or gradient.name not in ("linearGradient", "radialGradient"):
            warnings.append("%s: %s %s cannot be resolved and paints nothing"
                            % (name, property_name, colour))
            return 0
        colour, alpha = average_gradient_colour(gradient)
        warnings.append("%s: gradient %s flattened to #%06x"
                        % (name, gradient.attributes.get("id", "?"), colour or 0))
    if colour is None:
        return 0
    for key in (property_name + "-opacity", "opacity"):
        if key in state:
            alpha *= float(NUMBER.match(state[key].strip()).group(0))
    encoded = max(0, min(255, int(round(alpha * 255))))
    if encoded == 0:
        return 0
    return (encoded << 24) | colour


def collect_definitions(element, into):
    """Indexes every element that carries an id, so url(#...) can find it."""
    identifier = element.attributes.get("id")
    if identifier:
        into[identifier] = element
    for child in element.children:
        collect_definitions(child, into)


def walk(element, matrix, inherited, definitions, shapes, warnings, name):
    """Collects the filled shapes of one subtree, in painting order."""
    if element.name in ("defs", "clipPath", "mask", "linearGradient", "radialGradient",
                        "pattern", "symbol", "title", "desc", "metadata", "style", "filter"):
        # Definitions paint nothing where they stand. Every clipPath the emoji
        # sets use is the full viewBox rectangle, so honouring the clip would
        # change no pixel; a narrower one is reported instead of silently
        # cropping nothing.
        if element.name == "clipPath":
            rectangles = [c for c in element.children if c.name == "rect"]
            if len(element.children) != len(rectangles):
                warnings.append("%s: clipPath %s is not a plain rectangle and is ignored"
                                % (name, element.attributes.get("id", "?")))
        return

    matrix = multiply(matrix, parse_transform(element.attributes.get("transform")))
    state = dict(inherited)
    for key in ("fill", "fill-rule", "fill-opacity", "opacity",
                "stroke", "stroke-width", "stroke-opacity", "stroke-linecap"):
        if key in element.attributes:
            state[key] = element.attributes[key]

    if element.name == "use":
        reference = (element.attributes.get("href") or element.attributes.get("xlink:href") or "").lstrip("#")
        target = definitions.get(reference)
        if target is None:
            warnings.append("%s: <use> points at the unknown id %s" % (name, reference))
            return
        offset = [1.0, 0.0, 0.0, 1.0, length_of(element, "x"), length_of(element, "y")]
        walk(target, multiply(matrix, offset), state, definitions, shapes, warnings, name)
        return

    geometry = geometry_of(element)
    if geometry is not None:
        commands, points = geometry
        if commands:
            fill_argb = paint_of(state, "fill", "#000000", definitions, warnings, name)
            stroke_argb = paint_of(state, "stroke", None, definitions, warnings, name)
            stroke_width = 0.0
            if stroke_argb:
                # A stroke follows the geometry, so it is scaled the way the
                # coordinates are: by the area factor of the matrix.
                a, b, c, d = matrix[0], matrix[1], matrix[2], matrix[3]
                stroke_width = float(NUMBER.match(
                    state.get("stroke-width", "1").strip()).group(0)) * math.sqrt(abs(a * d - b * c))
            if fill_argb or stroke_argb:
                transformed = []
                for index in range(0, len(points), 2):
                    px, py = apply_matrix(matrix, points[index], points[index + 1])
                    transformed.extend((px, py))
                shapes.append(Shape(
                    fill_argb, state.get("fill-rule", "nonzero") == "evenodd",
                    commands, transformed, stroke_argb, stroke_width,
                    CAPS.get(state.get("stroke-linecap", "butt"), 0)))

    for child in element.children:
        walk(child, matrix, state, definitions, shapes, warnings, name)


def convert(path, name, warnings):
    """Reads one SVG file and returns its list of Shapes, normalized into the box."""
    with open(path, "r", encoding="utf-8") as handle:
        root = parse_xml(handle.read())
    if root.name != "svg":
        raise ConversionError("the root element is <%s>, not <svg>" % root.name)

    view_box = [float(v) for v in NUMBER.findall(root.attributes.get("viewBox", ""))]
    if len(view_box) != 4:
        view_box = [0.0, 0.0, length_of(root, "width", BOX), length_of(root, "height", BOX)]
    min_x, min_y, width, height = view_box
    if width <= 0 or height <= 0:
        raise ConversionError("the viewBox has no area")
    # Uniform scale into the box, then centred, so a non-square drawing keeps
    # its proportions instead of being stretched.
    scale = BOX / max(width, height)
    place = [scale, 0.0, 0.0, scale,
             -min_x * scale + (BOX - width * scale) / 2.0,
             -min_y * scale + (BOX - height * scale) / 2.0]

    definitions = {}
    collect_definitions(root, definitions)
    shapes = []
    for child in root.children:
        walk(child, place, {}, definitions, shapes, warnings, name)
    return shapes


# ---------------------------------------------------------------------------
# the container
# ---------------------------------------------------------------------------

def encode_drawing(shapes, name):
    """Packs the shapes of one emoji into its KVG1 drawing block."""
    out = bytearray()
    out += struct.pack("<H", len(shapes))
    for shape in shapes:
        flags = 1 if shape.even_odd else 0
        if shape.stroke_argb:
            flags |= 2
        out += struct.pack("<IB", shape.argb, flags)
        if shape.stroke_argb:
            width = max(1, min(0xFFFF, int(round(shape.stroke_width * UNIT))))
            out += struct.pack("<IHB", shape.stroke_argb, width, shape.stroke_caps)
        out += struct.pack("<H", len(shape.commands))
        out += bytes(bytearray(shape.commands))
        for value in shape.points:
            fixed = int(round(value * UNIT))
            if fixed < -32768 or fixed > 32767:
                raise ConversionError("%s: the coordinate %.2f does not fit 16 bits" % (name, value))
            out += struct.pack("<h", fixed)
    return bytes(out)


def build(source_folder, target_file):
    """Converts every SVG under the source folder into the target blob."""
    entries = []
    for folder, _, files in os.walk(source_folder):
        for file_name in files:
            if file_name.lower().endswith(".svg"):
                entries.append((os.path.splitext(file_name)[0], os.path.join(folder, file_name)))
    entries.sort()
    if not entries:
        raise ConversionError("no SVG file under %s" % source_folder)

    names = [name for name, _ in entries]
    duplicates = sorted({n for n in names if names.count(n) > 1})
    if duplicates:
        raise ConversionError("the same emoji name in more than one category: %s" % ", ".join(duplicates))
    if len(entries) > 0xFFFF:
        raise ConversionError("%d emojis do not fit the 16 bit count" % len(entries))

    warnings = []
    drawings = []
    for name, path in entries:
        shapes = convert(path, name, warnings)
        if not shapes:
            warnings.append("%s: nothing to draw" % name)
        drawings.append(encode_drawing(shapes, name))

    header = bytearray(b"KVG1")
    header += struct.pack("<H", len(entries))
    index_size = 0
    for name, _ in entries:
        index_size += 1 + len(name.encode("utf-8")) + 4
    offset = len(header) + index_size
    for (name, _), drawing in zip(entries, drawings):
        encoded = name.encode("utf-8")
        if len(encoded) > 0xFF:
            raise ConversionError("the emoji name %s is too long" % name)
        header += struct.pack("<B", len(encoded)) + encoded + struct.pack("<I", offset)
        offset += len(drawing)

    with open(target_file, "wb") as handle:
        handle.write(bytes(header))
        for drawing in drawings:
            handle.write(drawing)

    shape_count = sum(struct.unpack_from("<H", d)[0] for d in drawings)
    print("svg_to_kvg: %d emojis, %d shapes, %d bytes -> %s"
          % (len(entries), shape_count, offset, target_file))
    for warning in warnings:
        print("svg_to_kvg: %s" % warning)
    return 0


def main(argv):
    if len(argv) != 3:
        sys.stderr.write("usage: %s <svg-folder> <kvg-file>\n" % os.path.basename(argv[0]))
        return 2
    try:
        return build(argv[1], argv[2])
    except ConversionError as error:
        sys.stderr.write("svg_to_kvg: %s\n" % error)
        return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
