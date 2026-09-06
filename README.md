# KissAs3Fw

KissAs3Fw is an **ActionScript 3 application framework** for Adobe AIR. It is a
complete set of user interface components plus the application around them: the
layers a desktop application is displayed in, the managers feeding those
components with icons, sounds, emojis, fonts and translated labels, and the
request managers talking to the servers behind them.

The framework has no application of its own to start. It is the library the demo
applications of **[KissAs3Dm](https://github.com/kisscodesystems/KissAs3Dm)** are
built on, and this repository is the sources of it plus the unit test run that
checks every one of them.

- **Developed by:** Jozsef Kiss — KissCode Systems Kft

## Concept

- **One root object.** `Application` is the root of everything: every other
  object holds a reference to it and reaches the whole framework through it. It
  builds every configuration and every manager, and an application extending it
  replaces any one of those with its own by overriding the initialize method
  belonging to it.
- **Three layers.** A displayed application is the background, the middleground
  holding the widgets and the panels, and the foreground displaying the alerts.
- **Everything follows the stage.** The root object follows the size of the
  stage, so every object standing on it places and sizes itself against the
  window it is really in — there is no fixed layout anywhere.
- **The resources are embedded, and generated.** Icons, sounds, emojis and the
  label translations live in `src/com/kisscodesystems/KissAs3Fw/resource` as
  their own files, and the generator scripts next to them turn those into the
  enums and the managers serving them. Never edit a generated class by hand:
  change the resource and run the generator.
- **Everything logs into one sink.** Every object traces into the root object,
  and the tracer displays the collected messages frame by frame, on ten levels
  from framework debug to no logging at all.

## What is in it

| Package    | What it holds                                                                                                                                                                         |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ui`       | The components: `Board` `ButtonBar` `ButtonLink` `ButtonText` `Camera` `ColorPanel` `ColorPicker` `ContentMultiple` `ContentSingle` `DatePanel` `DatePicker` `Icon` `Image` `ListPanel` `ListPicker` `More` `Potmeter` `Rater` `SoundPlayer` `Switcher` `TextArea` `TextBox` `TextInput` `TextLabel` `VideoPlayer` `Watch` `Widget` `XmlLister` |
| `base`     | What those components are built of: the sprites, the shapes, the text fields, the scrolling, the panels, the lists, the buttons and the request manager under the three real ones.    |
| `app`      | The application itself: `Background`, `Middleground`, `Foreground`, `Widgets`, `PanelMenu`, `PanelSettings`, `LangSetter` and the `Tracer`.                                            |
| `manager`  | The services: icons, sounds, emojis, fonts, labels, cache, background, context menu, device id, servers, and the url / net connection requests.                                       |
| `config`   | `ComponentsConfig`, `DynamicsConfig` and `PropertiesConfig` — the three configurations an application replaces to look and behave the way it wants.                                   |
| `enum`     | The closed sets of values the framework works with: aligns, docks, languages, displaying styles, events, icons, sounds, emojis, text keys and the rest.                               |
| `util`     | `Utils`, `Crypto` (sha-256, hmac-sha-256, keystream cipher) and `VectorDrawings`.                                                                                                     |
| `user`     | `User`, the one holding the roles and the settings of whoever is using the application.                                                                                               |

## What you need

- **A JDK or JRE** — the compiler of the AIR SDK is a java program.
- **The Harman AIR SDK**, 51.2.1 or newer.
- **A valid Harman licence** (`adt.lic`) on Linux and on macOS. Without it the
  runtime prints the licence banner and quits without running anything. The
  runtime looks for it at `~/.airsdk/adt.lic`.
- **A display.** The test run really opens a window.

## Build

There is nothing to build here: the framework is a set of sources, and it is
compiled into the application using it. Check this repository out **next to**
[KissAs3Dm](https://github.com/kisscodesystems/KissAs3Dm) and build one of the
demo applications there — the build of that project asks for the `src` folder of
this one and compiles both together.

## Test

The unit test run compiles a test application against the current sources, runs
it with `adl` and prints the report of it:

```bash
bash test/KissAs3Fw_run_tests_linux.sh
```

```bash
bash test/KissAs3Fw_run_tests_macos.sh
```

```powershell
powershell -ExecutionPolicy Bypass -File .\test\KissAs3Fw_run_tests_windows.ps1
```

The first run asks where your AIR SDK is and stores the answer in `.AIRSDK_HOME`
in the root of this repository, so it is asked only once. That file is in
`.gitignore`: it belongs to your computer only. See the header of
`read_setting.sh` about it. The `AIRSDK` environment variable overrides it:

```bash
AIRSDK=/home/myUser/AIRSDK_51.2.1 bash test/KissAs3Fw_run_tests_linux.sh
```

The test application builds every component, checks it and writes
`build/testrun/as3/KissAs3Fw-results.txt`; the same report goes to the standard
output. It also shows the summary in its own window — the counts, the time, the
exit code and the failed assertions — and closes that window by itself a few
seconds later, which is why the script takes a little longer than the run. The
exit code is 0 when everything passed and 1 when something failed.

The test application is `test/com/kisscodesystems/KissAs3Fw/ApplicationUnitTest.as`,
one suite per class under `suite/`, and the harness the suites are written with is
`test/com/kisscodesystems/KissAs3Ut`.
