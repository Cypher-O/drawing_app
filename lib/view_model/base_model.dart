import 'dart:ui' as ui;
import 'package:drawing_app/utils/imports/general_import.dart';

/// Manages the state and logic for the drawing board.
class BaseModel extends BaseViewModel {
  late AnimationController uiAnimationController;
  late Animation<Offset> sliderAnimation;
  late Animation<Offset> paletteAnimation;
  late Animation<Offset> colorPaletteAnimation;
  late AnimationController animationController;

  // Check if there are any strokes on the board
  bool get hasStrokes => strokes.isNotEmpty;

  /// Creates a new BaseModel instance.
  BaseModel(TickerProvider tickerProvider) {
    _initializeAnimations(tickerProvider);
  }

  void _initializeAnimations(TickerProvider tickerProvider) {
    animationController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 300),
    );

    uiAnimationController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 300),
    );

    sliderAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0),
    ).animate(uiAnimationController);

    paletteAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(uiAnimationController);

    colorPaletteAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(uiAnimationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    uiAnimationController.dispose();
    super.dispose();
  }

  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      saveDrawing();
      DrawingStorage.saveBackgroundColor(AppColors.whiteColor);
    }
  }

  /// Sets the background color of the drawing board.
  void setSelectedBackGroundColor(Color color) {
    AppColors.whiteColor = color;
    DrawingStorage.saveBackgroundColor(color);
    notifyListeners();
  }

  /// Resets the background color to default (white) and clears it from SharedPreferences.
  void resetBackgroundColor() {
    AppColors.whiteColor = Colors.white; // Default background color
    DrawingStorage.clearBackgroundColor(); // Clear from SharedPreferences
    notifyListeners();
  }

  /// Sets the stroke color for drawing.
  void setSelectedColor(Color color) {
    AppColors.blackColor = color;
    notifyListeners();
  }

  Future<void> saveDrawing() async {
    await DrawingStorage.saveDrawing(strokes);
  }

  Future<void> loadDrawing() async {
    if (await DrawingStorage.hasSavedDrawing()) {
      strokes = await DrawingStorage.loadDrawing();
      AppColors.whiteColor = await DrawingStorage.loadBackgroundColor();
      notifyListeners();
    }
  }

  /// Updates the stroke width for drawing.
  void updateStrokeWidth(double value) {
    strokeWidth = value;
    notifyListeners();
  }

  // Handles the start of a drawing stroke
  void onPanStart(DragStartDetails details) {
    _toggleDrawing(true);
    isDrawing = true;
    if (!isEraserMode) {
      redoStack.clear();
      currentStroke = Stroke(
        color: AppColors.blackColor,
        strokeWidth: strokeWidth,
        points: [
          details.localPosition,
        ],
      );
    }
    notifyListeners();
  }

  // Handles the continuation of a drawing stroke
  void onPanUpdate(DragUpdateDetails details) {
    if (isEraserMode) {
      // Erase strokes that intersect with the current position
      eraseAtPoint(details.localPosition);
      saveDrawing();
    } else {
      if (currentStroke == null) {
        currentStroke = Stroke(
          color: AppColors.blackColor,
          strokeWidth: strokeWidth,
          points: [
            details.localPosition,
          ],
        );
      } else {
        currentStroke!.segments.last.add(
          details.localPosition,
        );
      }
    }
    notifyListeners();
  }

  // Handles the end of a drawing stroke
  void onPanEnd(DragEndDetails details) {
    _toggleDrawing(false);
    if (!isEraserMode && currentStroke != null) {
      strokes.add(
        currentStroke!,
      );
      currentStroke = null;
      canUndo = true;
      canRedo = false;
      saveDrawing();
    }
    notifyListeners();
  }

  void _toggleDrawing(bool isDrawing) {
    isDrawing = isDrawing;
    if (isDrawing) {
      uiAnimationController.forward();
    } else {
      uiAnimationController.reverse();
    }
    notifyListeners();
  }

  /// Toggles between eraser and brush mode.
  void toggleEraserMode() {
    isEraserMode = !isEraserMode;
    notifyListeners();
  }

  /// Toggles the expanded state of the color palette.
  void toggleExpanded() {
    isExpanded = !isExpanded;
    if (isExpanded) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    notifyListeners();
  }

  /// Erases strokes at the given point.
  void eraseAtPoint(Offset point) {
    const double eraseRadius = 20.0;
    bool strokeModified = false;

    for (int i = strokes.length - 1; i >= 0; i--) {
      Stroke stroke = strokes[i];
      List<List<Offset>> newSegments = [];
      bool segmentModified = false;

      for (List<Offset> segment in stroke.segments) {
        List<List<Offset>> subSegments = splitSegment(
          segment,
          point,
          eraseRadius,
        );
        if (subSegments.length != 1 ||
            subSegments[0].length != segment.length) {
          segmentModified = true;
        }
        newSegments.addAll(
          subSegments,
        );
      }

      if (segmentModified) {
        strokeModified = true;
        // Remove segments that are too short
        newSegments.removeWhere((segment) => segment.length < 2);

        if (newSegments.isEmpty) {
          strokes.removeAt(i);
        } else {
          stroke.segments = newSegments;
          stroke.points = newSegments.expand((segment) => segment).toList();
        }
      }
    }

    if (strokeModified) {
      canUndo = true;
      canRedo = false;
      redoStack.clear();
    }
  }

  /// Splits a segment of a stroke based on the eraser position.
  List<List<Offset>> splitSegment(
      List<Offset> segment, Offset erasePoint, double eraseRadius) {
    List<List<Offset>> subSegments = [];
    List<Offset> currentSubSegment = [];

    for (int i = 0; i < segment.length; i++) {
      if ((segment[i] - erasePoint).distance > eraseRadius) {
        currentSubSegment.add(segment[i]);
      } else {
        if (currentSubSegment.isNotEmpty) {
          subSegments.add(
            List.from(
              currentSubSegment,
            ),
          );
          currentSubSegment.clear();
        }
      }
    }

    if (currentSubSegment.isNotEmpty) {
      subSegments.add(
        currentSubSegment,
      );
    }
    return subSegments;
  }

  /// Undoes the last drawing action.
  void undo() {
    if (strokes.isNotEmpty) {
      redoStack.add(
        strokes.removeLast(),
      );
      canRedo = true; // Enable redo after undoing
      canUndo = strokes.isNotEmpty; // Check if more undo are available
      saveDrawing();
      notifyListeners();
    }
  }

  /// Redoes the last undone drawing action.
  void redo() {
    if (redoStack.isNotEmpty) {
      strokes.add(
        redoStack.removeLast(),
      );
      canUndo = true; // Enable undo after redoing
      canRedo = redoStack.isNotEmpty; // Check if more redos are available
      saveDrawing();
      notifyListeners();
    }
  }

  /// Clears the drawing board.
  void clearBoard() {
    strokes.clear();
    redoStack.clear();
    canUndo = false; // Disable undo after clearing
    canRedo = false; // Disable redo after clearing
    saveDrawing();
    resetBackgroundColor();
    notifyListeners();
  }

  // Method to save the drawing as a PNG image
  Future<bool> saveDrawingToGallery(
      BuildContext context, GlobalKey repaintBoundaryKey) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            const Center(child: CircularProgressIndicator()),
      );

      RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception("Failed to get image data");
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'drawing_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${directory.path}/$fileName';
      File imgFile = File(filePath);
      await imgFile.writeAsBytes(pngBytes);
      notifyListeners();

      final result = await GallerySaver.saveImage(imgFile.path);
      if (result != true) {
        throw Exception("Failed to save image to gallery");
      }

      // Close loading indicator
      Navigator.pop(repaintBoundaryKey.currentContext!);

      // Show success message
      _showSnackBar(repaintBoundaryKey.currentContext!, 'Drawing saved successfully!');
      return true;
    } catch (e) {
      // Close loading indicator
      Navigator.pop(repaintBoundaryKey.currentContext!);

      // Show error message
      _showSnackBar(repaintBoundaryKey.currentContext!, 'Error saving drawing: ${e.toString()}');
      return false;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
