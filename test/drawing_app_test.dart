import 'package:drawing_app/utils/imports/general_import.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTicker implements Ticker {
  FakeTicker(this._onTick);
  final TickerCallback _onTick;
  
  @override
  void stop({bool canceled = false}) {}

  @override
  void dispose() {}

  @override
  bool get isActive => false;

  @override
  bool get isTicking => false;

  @override
  bool get muted => false;

  @override
  void absorbTicker(Ticker originalTicker) {}

  @override
  String toString({bool debugIncludeStack = false}) => 'FakeTicker';

  @override
  TickerFuture scheduleTick({bool rescheduling = false}) => TickerFuture.complete();

  @override
  void unscheduleTick() {}

  @override
  void resetTimer() {}

  @override
  void unmuted() {}

  @override
  String? debugLabel;

  @override
  // TODO: implement shouldScheduleTick
  bool get shouldScheduleTick => true;

  @override
  DiagnosticsNode describeForError(String name) {
    return DiagnosticsNode.message('FakeTicker');
  }

  @override
  set muted(bool value) {
    // TODO: implement muted
  }

  @override
  // TODO: implement scheduled
  bool get scheduled => false;

  @override
  TickerFuture start() {
    return TickerFuture.complete();
  }
}

// Mock TickerProvider
class MockTickerProvider extends Mock implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => FakeTicker(onTick);
}

void main() {
  late BaseModel baseModel;
  late MockTickerProvider mockTickerProvider;

  // Ensure Flutter bindings are initialized for testing
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({}); // Initialize SharedPreferences mock
  });

  setUp(() {
    mockTickerProvider = MockTickerProvider();
    baseModel = BaseModel(mockTickerProvider);
  });

  group('BaseModel Tests', () {
    test('Initial state', () {
      expect(baseModel.hasStrokes, isFalse);
      expect(isEraserMode, isFalse);
      expect(isExpanded, isFalse);
    });

    test('setSelectedBackGroundColor updates color', () {
      const newColor = Colors.blue;
      baseModel.setSelectedBackGroundColor(newColor);
      expect(AppColors.whiteColor, equals(newColor));
    });

    test('toggleEraserMode switches between modes', () {
      expect(isEraserMode, isFalse);
      baseModel.toggleEraserMode();
      expect(isEraserMode, isTrue);
      baseModel.toggleEraserMode();
      expect(isEraserMode, isFalse);
    });

    test('updateStrokeWidth changes stroke width', () {
      const newWidth = 5.0;
      baseModel.updateStrokeWidth(newWidth);
      expect(strokeWidth, equals(newWidth));
    });

    test('onPanStart initializes currentStroke', () {
      final details = DragStartDetails(localPosition: Offset.zero);
      baseModel.onPanStart(details);
      expect(currentStroke, isNotNull);
      expect(isDrawing, isTrue);
    });

    test('onPanEnd adds stroke and clears currentStroke', () {
      baseModel.onPanStart(DragStartDetails(localPosition: Offset.zero));
      baseModel.onPanEnd(DragEndDetails());
      expect(baseModel.hasStrokes, isTrue);
      expect(currentStroke, isNull);
      expect(canUndo, isTrue);
      expect(canRedo, isFalse);
    });

    test('undo removes last stroke', () {
      baseModel.onPanStart(DragStartDetails(localPosition: Offset.zero));
      baseModel.onPanEnd(DragEndDetails());
      expect(baseModel.hasStrokes, isTrue);
      baseModel.undo();
      expect(baseModel.hasStrokes, isFalse);
      expect(canRedo, isTrue);
    });

    test('redo restores undone stroke', () {
      baseModel.onPanStart(DragStartDetails(localPosition: Offset.zero));
      baseModel.onPanEnd(DragEndDetails());
      baseModel.undo();
      baseModel.redo();
      expect(baseModel.hasStrokes, isTrue);
      expect(canUndo, isTrue);
    });

    test('clearBoard removes all strokes', () {
      baseModel.onPanStart(DragStartDetails(localPosition: Offset.zero));
      baseModel.onPanEnd(DragEndDetails());
      baseModel.clearBoard();
      expect(baseModel.hasStrokes, isFalse);
      expect(canUndo, isFalse);
      expect(canRedo, isFalse);
    });
  });

  group('DrawingStorage Tests', () {
    test('saveDrawing and loadDrawing persist strokes', () async {
      final stroke = Stroke(
        color: Colors.black,
        strokeWidth: 2.0,
        points: [Offset.zero, const Offset(1, 1)],
      );
      await DrawingStorage.saveDrawing([stroke]);
      final loadedStrokes = await DrawingStorage.loadDrawing();
      expect(loadedStrokes.length, equals(1));
      expect(loadedStrokes[0].color, equals(stroke.color));
      expect(loadedStrokes[0].strokeWidth, equals(stroke.strokeWidth));
      expect(loadedStrokes[0].points, equals(stroke.points));
    });

    test('hasSavedDrawing returns correct value', () async {
      expect(await DrawingStorage.hasSavedDrawing(), isFalse);
      await DrawingStorage.saveDrawing([
        Stroke(color: Colors.black, strokeWidth: 2.0, points: [Offset.zero])
      ]);
      expect(await DrawingStorage.hasSavedDrawing(), isTrue);
    });

    test('saveBackgroundColor and loadBackgroundColor persist color', () async {
      const Color expectedColor = Colors.red;

      // Save the color
      await DrawingStorage.saveBackgroundColor(expectedColor);

      // Load the saved color
      final Color loadedColor = await DrawingStorage.loadBackgroundColor();

      // Assert the loaded color matches the expected color
      expect(loadedColor, isInstanceOf<Color>());
      expect(loadedColor, equals(expectedColor));
    });
  });
}