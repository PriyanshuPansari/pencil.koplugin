# pencil.koplugin

## Information

This has been tested on:

- Kobo Libra Colour/Kobo Stylus 2/Epub format

**This will currently only work on Kobo devices! I will attempt to add other device support by request and at a later date**

If you resize your book while reading it, your annotations will be WONKY. This is something I will eventually address but for now, get your book set before you start writing.

## Features

- **Pen tip**: Draw annotations on your ebooks
- **Eraser end**: Flip your stylus over to erase strokes instantly
- **Color selection**: Hold the pen still to open a color picker with 10 color options
- **Undo**: Undo your last stroke or eraser action
- **Clear strokes**: Clear annotations for the current page or the entire document
- **Enable/disable toggle**: Turn the plugin on or off via the menu or a mapped gesture
- **Per-document storage**: Annotations are saved with each book
- **Input debug mode**: Log raw stylus events to help diagnose detection issues

## Instructions for Installation

1. Download both the `pencil.koplugin` directory and the `input.lua` file from this repository.
2. Replace the `/frontend/device/input.lua` with the downloaded file. This enables the plugin to intercept the stylus input, separate it from touch inputs, and detect the eraser end.
3. Copy the `pencil.koplugin` directory into the `/plugins` directory of KOReader.

## Configuring the Pencil Plugin

1. Enable the plugin from the Pencil menu (Top menu > More tools > Pencil > Enabled)
2. Optionally map actions to gestures in Gesture Manager:
   - **Pencil: toggle on/off** — enable or disable the plugin
   - **Pencil: toggle pencil/eraser** — switch between tools
   - **Pencil: select pencil** — switch to pencil
   - **Pencil: select eraser** — switch to eraser
   - **Pencil: undo** — undo last stroke or eraser action

## Questions or Issues with the Plugin

If you have any questions or a feature request, please submit an issue in this repo.
If you're experiencing issues with the plugin, please enable input debug mode in the Pencil menu, reproduce the issue, and include the debug log file in your issue report.

## Features In the Pipeline

1. Export of annotations
2. Handling changing canvas size

## Acknowledgements

Eraser end detection based on techniques from [eraser.koplugin](https://github.com/SimonLiu423/eraser.koplugin) by SimonLiu.

xoxo
