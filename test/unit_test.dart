import 'package:drawing_app/utils/imports/general_import.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTickerProvider extends Mock implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

void main() {
   // Ensure Flutter bindings are initialized
  TestWidgetsFlutterBinding.ensureInitialized();
  group('BaseModel Tests', () {
    late BaseModel viewModel;
    late MockTickerProvider mockTickerProvider;

    setUp(() {
      mockTickerProvider = MockTickerProvider();
      viewModel = BaseModel(mockTickerProvider);
    });

    test('Initial state', () {
      expect(AppColors.blackColor, equals(Colors.black));
      expect(AppColors.whiteColor, equals(Colors.white));
      expect(strokeWidth, equals(5));
      expect(strokes, isEmpty);
      expect(currentStroke, isNull);
      expect(isEraserMode, isFalse);
    });

    test('Toggle eraser mode', () {
      expect(isEraserMode, isFalse);
      viewModel.toggleEraserMode();
      expect(isEraserMode, isTrue);
    });

    test('Update stroke width', () {
      viewModel.updateStrokeWidth(10);
      expect(strokeWidth, equals(10));
    });

    test('Add stroke on pan start', () {
      final startDetails = DragStartDetails(localPosition: const Offset(10, 10));
      viewModel.onPanStart(startDetails);

      expect(currentStroke, isNotNull);
      expect(currentStroke!.points, contains(const Offset(10, 10)));
    });

    test('Update stroke on pan update', () {
      final startDetails = DragStartDetails(localPosition: const Offset(10, 10));
      viewModel.onPanStart(startDetails);

      final updateDetails = DragUpdateDetails(localPosition: const Offset(20, 20), globalPosition: const Offset(20, 20));

      viewModel.onPanUpdate(updateDetails);

      expect(currentStroke!.points, contains(const Offset(20, 20)));
    });

    test('Add stroke to list on pan end', () {
      final startDetails = DragStartDetails(localPosition: const Offset(10, 10));
      viewModel.onPanStart(startDetails);

      final updateDetails = DragUpdateDetails(localPosition: const Offset(20, 20), globalPosition: const Offset(20, 20));

      viewModel.onPanUpdate(updateDetails);

      final endDetails = DragEndDetails();
      viewModel.onPanEnd(endDetails);

      expect(strokes, isNotEmpty);
      expect(currentStroke, isNull);
    });

    test('Clear board', () {
      final startDetails = DragStartDetails(localPosition: const Offset(10, 10));
      viewModel.onPanStart(startDetails);

      final updateDetails = DragUpdateDetails(localPosition: const Offset(20, 20), globalPosition: const Offset(20, 20));

      viewModel.onPanUpdate(updateDetails);

      final endDetails = DragEndDetails();
      viewModel.onPanEnd(endDetails);

      expect(strokes, isNotEmpty);
      viewModel.clearBoard();
      expect(strokes, isEmpty);
    });
  });
}