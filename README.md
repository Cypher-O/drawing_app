# Flutter Drawing App

A simple yet powerful drawing application built with Flutter. This app allows users to create digital sketches, doodles, and artworks with various tools and features.

## Features

- Freehand drawing with adjustable brush sizes
- Color picker for selecting custom colors
- Eraser tool for easy corrections
- Undo and Redo functionality
- Clear canvas option
- Save drawings to device gallery
- Automatic saving and loading of drawings
- Continue drawing from where you left off, even after closing the app

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter SDK (version 2.0 or higher)
- Dart SDK (version 2.12 or higher)
- Android Studio / VS Code with Flutter extensions
- An Android or iOS device/emulator for testing

## Tools used in building

- flutter `v3.19.5 - mobile sdk`
- stacked `state management`
- iconsax `icon pack`
- shared_preferences `local storage`
- path_provider `file access`
- gallery_saver `save images`
- mockito `unit testing`
- build_runner `code generation`
- flutter_launcher_icons `app icon`
- flutter_native_splash `splash screen`

## Installation

1. Clone the repository:
   git clone <https://github.com/Cypher-O/drawing_app.git>

2. Navigate to the project directory:
   cd drawing_app

3. Get the dependencies:
   flutter pub get

4. Run the app:
   flutter run

## Usage

1. **Drawing**: Tap and drag on the screen to draw. The default color is black.

2. **Change Color**: Tap the color picker icon to select a different color for drawing.

3. **Adjust Brush Size**: Use the slider to adjust the thickness of the brush stroke.

4. **Eraser**: Tap the eraser icon to switch to eraser mode. Drag over existing strokes to erase them.

5. **Undo/Redo**: Use the undo and redo buttons to reverse or reapply recent actions.

6. **Clear Canvas**: Tap the trash can icon to clear the entire canvas.

7. **Save Drawing**: Tap the save icon to save your drawing to the device gallery.

8. **Automatic Saving**: Your drawing is automatically saved as you draw. When you reopen the app, your previous drawing will be loaded automatically, allowing you to continue where you left off.

## Running Tests

To run the unit and widget tests for this project:

1. Ensure you're in the project root directory.

2. Run the following command:
   flutter test

This will execute all the tests in the `test/` directory.

## Contributing

Contributions are welcome! Here's how you can contribute:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch-name`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature-branch-name`.
5. Create a pull request.

Please make sure to update tests as appropriate and adhere to the existing coding style.

## Acknowledgments

- Flutter and Dart teams for providing an excellent framework and language.
- Contributors and open-source projects that inspired this app.

## App Screenshots & Gif

| ![Image 1](/assets/screenshots/screenshot1.png) | ![Image 2](/assets/screenshots/screenshot2.png) |
|:--:|:--:|
| Image 1 | Image 2 |

| ![Image 3](/assets/screenshots/screenshot3.png) | ![Animated GIF](/assets/gif/app.gif) |
|:--:|:--:|
| Image 3 | Animated GIF |

## Contact

If you have any questions, feel free to reach out to Olumide Awodeji at <awodejiolumidekolade@gmail.com>.
