WHERE DO THESE EMOJIS COME FROM?

Every file of this folder is an SVG: a vector drawing. That is what makes an emoji of
this framework sharp at sixteen pixels and at four hundred alike. ActionScript cannot
display an SVG itself, so ../svg_to_kvg.py flattens all of them into emojis.kvg at build
time, and ../../util/VectorDrawings.as draws them out of that blob. Never edit
emojis.kvg: the generate_classes script of the resource folder writes it from scratch.

THE DRAWINGS

Almost all of the nine hundred drawings are the Flat style of the Microsoft Fluent Emoji
set, taken unchanged. Every emoji of this folder is a drawing of its own: no two files
here hold the same bytes, and no two of them point at the same Fluent asset either.

  https://github.com/microsoft/fluentui-emoji

  MIT License
  Copyright (c) Microsoft Corporation.

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

Two groups of them are not taken as they stand:

  people/   Fluent ships no drawing for the emojis that hold more than one person, so
            people_boy_boy, people_girl_boy, people_girl_girl, people_man_woman_boy,
            people_woman_heart_man and people_woman_kiss_man set the Fluent figures
            next to each other inside one box, and keep the style of the rest that way.

  the rest  Forty-two emojis of this set are of this framework and of no standard at
            all: the text plates of labels/, the badges of smileys/ and objects/, a few
            marks. Those are drawn out of plain geometry, of Fluent figures and, where
            there are letters on them, of the outlines of the FreeSans standing in
            ../font. None of them traces anybody's trademark.

Four names of the older set are gone, because they carried the very same emoji as
another name of it and Fluent has no second drawing to tell them apart:

  smileys_bust_in_silhouette   the same as people_bust
  smileys_busts_in_silhouette  the same as people_busts
  images_fireworks_on_image    the same as smileys_fireworks
  smileys_grinning_cat_face    the same as smileys_cat_face, because Fluent ships one
                               and the same file for the cat face and the grinning cat

HOW TO ADD ONE

Drop the SVG into the category folder it belongs to, name it category_name.svg, then run
the generate_classes script of the resource folder. The converter reads a plain subset
of SVG: path, rect, circle, ellipse, polygon, polyline and line, inside groups that may
carry a transform, filled and stroked with flat colours. It resolves the elliptical arcs
and the shorthand path commands itself, and it says so on its output when it meets
something it cannot express, so watch what it prints. Two emojis must never end up with
the same drawing: a name of its own asks for a drawing of its own.
