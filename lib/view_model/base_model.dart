import 'package:drawing_app/utils/imports/general_import.dart';

class BaseModel extends BaseViewModel {
bool _isFullScreen = false;

  bool get isFullScreen => isFullScreen;

  late AnimationController uiAnimationController;
  late Animation<Offset> sliderAnimation;
  late Animation<Offset> paletteAnimation;
  late AnimationController animationController;

  BaseModel(TickerProvider tickerProvider) {
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
  }

  @override
  void dispose() {
    animationController.dispose();
    uiAnimationController.dispose();
    super.dispose();
  }

  void setSelectedBackGroundColor(Color color) {
    AppColors.whiteColor = color;
    notifyListeners();
  }

  void setSelectedColor(Color color) {
    AppColors.blackColor = color;
    notifyListeners();
  }

  void updateStrokeWidth(double value) {
    strokeWidth = value;
    notifyListeners();
  }

  toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  // Handle the start of a drawing stroke
  void onPanStart(DragStartDetails details) {
    _toggleDrawing(true);
    if (!isEraserMode) {
      redoStack.clear();
      currentStroke = Stroke(
        color: AppColors.blackColor,
        strokeWidth: strokeWidth,
        points: [details.localPosition],
      );
    }
    notifyListeners();
  }

  // Handle the continuation of a drawing stroke
  void onPanUpdate(DragUpdateDetails details) {
    if (isEraserMode) {
      // Erase strokes that intersect with the current position
      eraseAtPoint(details.localPosition);
    } else {
      if (currentStroke == null) {
        currentStroke = Stroke(
          color: AppColors.blackColor,
          strokeWidth: strokeWidth,
          points: [details.localPosition],
        );
      } else {
        currentStroke!.segments.last.add(details.localPosition);
      }
    }
    notifyListeners();
  }

  // Handle the end of a drawing stroke
  void onPanEnd(DragEndDetails details) {
    _toggleDrawing(false);
    if (!isEraserMode && currentStroke != null) {
      strokes.add(currentStroke!);
      currentStroke = null;
      canUndo = true;
      canRedo = false;
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

  void toggleEraserMode() {
    isEraserMode = !isEraserMode;
    notifyListeners();
  }

  void toggleExpanded() {
    isExpanded = !isExpanded;
    if (isExpanded) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    notifyListeners();
  }

  void eraseAtPoint(Offset point) {
    const double eraseRadius = 20.0;
    bool strokeModified = false;

    for (int i = strokes.length - 1; i >= 0; i--) {
      Stroke stroke = strokes[i];
      List<List<Offset>> newSegments = [];
      bool segmentModified = false;

      for (List<Offset> segment in stroke.segments) {
        List<List<Offset>> subSegments =
            splitSegment(segment, point, eraseRadius);
        if (subSegments.length != 1 ||
            subSegments[0].length != segment.length) {
          segmentModified = true;
        }
        newSegments.addAll(subSegments);
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

  List<List<Offset>> splitSegment(
      List<Offset> segment, Offset erasePoint, double eraseRadius) {
    List<List<Offset>> subSegments = [];
    List<Offset> currentSubSegment = [];

    for (int i = 0; i < segment.length; i++) {
      if ((segment[i] - erasePoint).distance > eraseRadius) {
        currentSubSegment.add(segment[i]);
      } else {
        if (currentSubSegment.isNotEmpty) {
          subSegments.add(List.from(currentSubSegment));
          currentSubSegment.clear();
        }
      }
    }

    if (currentSubSegment.isNotEmpty) {
      subSegments.add(currentSubSegment);
    }

    return subSegments;
  }

  void undo() {
    if (strokes.isNotEmpty) {
      redoStack.add(strokes.removeLast());
      canRedo = true; // Enable redo after undoing
      canUndo = strokes.isNotEmpty; // Check if more undo are available
      notifyListeners();
    }
  }

  void redo() {
    if (redoStack.isNotEmpty) {
      strokes.add(redoStack.removeLast());
      canUndo = true; // Enable undo after redoing
      canRedo = redoStack.isNotEmpty; // Check if more redos are available
      notifyListeners();
    }
  }

  void clearBoard() {
    strokes.clear();
    redoStack.clear();
    canUndo = false; // Disable undo after clearing
    canRedo = false; // Disable redo after clearing
    notifyListeners();
  }
}
