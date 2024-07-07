















// import 'package:drawing_app/utils/imports/general_import.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// // Mock TickerProvider
// class MockTickerProvider extends Mock implements TickerProvider {}
//
// void main() {
//   late BaseModel baseModel;
//   late MockTickerProvider mockTickerProvider;
//
//   setUp(() {
//     mockTickerProvider = MockTickerProvider();
//     baseModel = BaseModel(mockTickerProvider);
//     SharedPreferences.setMockInitialValues({});
//   });
//
//   group('BaseModel Tests', () {
//     test('Initial state', () {
//       expect(baseModel.hasStrokes, isFalse);
//       expect(isEraserMode, isFalse);
//       expect(isExpanded, isFalse);
//     });
//
//     test('setSelectedBackGroundColor updates color and saves', () async {
//       const newColor = Colors.blue;
//       baseModel.setSelectedBackGroundColor(newColor);
//       expect(AppColors.whiteColor, equals(newColor));
//
//       // Wait a bit to ensure the background color has been saved
//       await Future.delayed(const Duration(milliseconds: 100));
//       final savedColor = await DrawingStorage.loadBackgroundColor();
//       expect(savedColor, equals(newColor));
//     });
//
//     test('toggleEraserMode switches between modes', () {
//       expect(isEraserMode, isFalse);
//       baseModel.toggleEraserMode();
//       expect(isEraserMode, isTrue);
//       baseModel.toggleEraserMode();
//       expect(isEraserMode, isFalse);
//     });
//
//     test('updateStrokeWidth changes stroke width', () {
//       const newWidth = 5.0;
//       baseModel.updateStrokeWidth(newWidth);
//       expect(strokeWidth, equals(newWidth));
//     });
//
//     test('onPanStart initializes currentStroke', () {
//       final details = DragStartDetails(localPosition: Offset.zero);
//       baseModel.onPanStart(details);
//       expect(currentStroke, isNotNull);
//       expect(isDrawing, isTrue);
//     });
//
//     test('onPanEnd adds stroke and clears currentStroke', () {
//       // First start a stroke
//       baseModel.onPanStart(DragStartDetails(localPosition: Offset.zero));
//
//       // Then end it
//       baseModel.onPanEnd(DragEndDetails());
//
//       expect(baseModel.hasStrokes, isTrue);
//       expect(currentStroke, isNull);
//       expect(canUndo, isTrue);
//       expect(canRedo, isFalse);
//     });
//
//     test('undo removes last stroke', () {
//       // Add a stroke
//       baseModel.onPanStart(DragStartDetails(localPosition: Offset.zero));
//       baseModel.onPanEnd(DragEndDetails());
//
//       expect(baseModel.hasStrokes, isTrue);
//
//       baseModel.undo();
//
//       expect(baseModel.hasStrokes, isFalse);
//       expect(canRedo, isTrue);
//     });
//
//     test('redo restores undone stroke', () {
//       // Add and undo a stroke
//       baseModel.onPanStart(DragStartDetails(localPosition: Offset.zero));
//       baseModel.onPanEnd(DragEndDetails());
//       baseModel.undo();
//
//       expect(baseModel.hasStrokes, isFalse);
//
//       baseModel.redo();
//
//       expect(baseModel.hasStrokes, isTrue);
//       expect(canUndo, isTrue);
//     });
//
//     test('clearBoard removes all strokes', () {
//       // Add some strokes
//       baseModel.onPanStart(DragStartDetails(localPosition: Offset.zero));
//       baseModel.onPanEnd(DragEndDetails());
//       baseModel.onPanStart(DragStartDetails(localPosition: Offset.zero));
//       baseModel.onPanEnd(DragEndDetails());
//
//       expect(baseModel.hasStrokes, isTrue);
//
//       baseModel.clearBoard();
//
//       expect(baseModel.hasStrokes, isFalse);
//       expect(canUndo, isFalse);
//       expect(canRedo, isFalse);
//     });
//   });
//
//   group('DrawingStorage Tests', () {
//     test('saveDrawing and loadDrawing persist strokes', () async {
//       final stroke = Stroke(
//         color: Colors.black,
//         strokeWidth: 2.0,
//         points: [Offset.zero, const Offset(1, 1)],
//       );
//       await DrawingStorage.saveDrawing([stroke]);
//
//       final loadedStrokes = await DrawingStorage.loadDrawing();
//       expect(loadedStrokes.length, equals(1));
//       expect(loadedStrokes[0].color, equals(stroke.color));
//       expect(loadedStrokes[0].strokeWidth, equals(stroke.strokeWidth));
//       expect(loadedStrokes[0].points, equals(stroke.points));
//     });
//
//     test('hasSavedDrawing returns correct value', () async {
//       expect(await DrawingStorage.hasSavedDrawing(), isFalse);
//
//       await DrawingStorage.saveDrawing([
//         Stroke(color: Colors.black, strokeWidth: 2.0, points: [Offset.zero])
//       ]);
//
//       expect(await DrawingStorage.hasSavedDrawing(), isTrue);
//     });
//
//     test('saveBackgroundColor and loadBackgroundColor persist color', () async {
//       const color = Colors.red;
//       await DrawingStorage.saveBackgroundColor(color);
//
//       final loadedColor = await DrawingStorage.loadBackgroundColor();
//       expect(loadedColor, equals(color));
//     });
//   });
// }










// class MockTickerProvider extends Mock implements TickerProvider {
//   @override
//   Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
// }
//
// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   group('BaseModel Tests', () {
//     late BaseModel viewModel;
//     late MockTickerProvider mockTickerProvider;
//
//     setUp(() {
//       mockTickerProvider = MockTickerProvider();
//       viewModel = BaseModel(mockTickerProvider);
//     });
//
//     test('Initial state', () {
//       expect(AppColors.blackColor, equals(Colors.black));
//       expect(AppColors.whiteColor, equals(Colors.white));
//       expect(strokeWidth, equals(5));
//       expect(strokes, isEmpty);
//       expect(currentStroke, isNull);
//       expect(isEraserMode, isFalse);
//       expect(canUndo, isFalse);
//       expect(canRedo, isFalse);
//     });
//
//     test('Toggle eraser mode', () {
//       expect(isEraserMode, isFalse);
//       viewModel.toggleEraserMode();
//       expect(isEraserMode, isTrue);
//     });
//
//     test('Update stroke width', () {
//       viewModel.updateStrokeWidth(10);
//       expect(strokeWidth, equals(10));
//     });
//
//     test('Add stroke on pan start', () {
//       final startDetails =
//           DragStartDetails(localPosition: const Offset(10, 10));
//       viewModel.onPanStart(startDetails);
//
//       expect(currentStroke, isNotNull);
//       expect(currentStroke!.points, contains(const Offset(10, 10)));
//     });
//
//     test('Update stroke on pan update', () {
//       final startDetails =
//           DragStartDetails(localPosition: const Offset(10, 10));
//       viewModel.onPanStart(startDetails);
//
//       final updateDetails = DragUpdateDetails(
//           localPosition: const Offset(20, 20),
//           globalPosition: const Offset(20, 20));
//       viewModel.onPanUpdate(updateDetails);
//
//       expect(currentStroke!.segments.last, contains(const Offset(20, 20)));
//     });
//
//     test('Add stroke to list on pan end', () {
//       final startDetails =
//           DragStartDetails(localPosition: const Offset(10, 10));
//       viewModel.onPanStart(startDetails);
//
//       final updateDetails = DragUpdateDetails(
//           localPosition: const Offset(20, 20),
//           globalPosition: const Offset(20, 20));
//       viewModel.onPanUpdate(updateDetails);
//
//       final endDetails = DragEndDetails();
//       viewModel.onPanEnd(endDetails);
//
//       expect(strokes, isNotEmpty);
//       expect(currentStroke, isNull);
//       expect(canUndo, isTrue);
//     });
//
//     test('Clear board', () {
//       // Add a stroke
//       viewModel
//           .onPanStart(DragStartDetails(localPosition: const Offset(10, 10)));
//       viewModel.onPanUpdate(DragUpdateDetails(
//           localPosition: const Offset(20, 20),
//           globalPosition: const Offset(20, 20)));
//       viewModel.onPanEnd(DragEndDetails());
//
//       expect(strokes, isNotEmpty);
//       viewModel.clearBoard();
//       expect(strokes, isEmpty);
//       expect(canUndo, isFalse);
//       expect(canRedo, isFalse);
//     });
//
//     test('Undo and Redo', () {
//       // Add a stroke
//       viewModel
//           .onPanStart(DragStartDetails(localPosition: const Offset(10, 10)));
//       viewModel.onPanUpdate(DragUpdateDetails(
//           localPosition: const Offset(20, 20),
//           globalPosition: const Offset(20, 20)));
//       viewModel.onPanEnd(DragEndDetails());
//
//       expect(strokes.length, equals(1));
//       expect(canUndo, isTrue);
//       expect(canRedo, isFalse);
//
//       // Undo
//       viewModel.undo();
//       expect(strokes, isEmpty);
//       expect(canUndo, isFalse);
//       expect(canRedo, isTrue);
//
//       // Redo
//       viewModel.redo();
//       expect(strokes.length, equals(1));
//       expect(canUndo, isTrue);
//       expect(canRedo, isFalse);
//     });
//   });
//
//   group('DrawingBoard Widget Tests', () {
//     testWidgets('Initial rendering', (WidgetTester tester) async {
//       await tester.pumpWidget(const MaterialApp(home: DrawingBoard()));
//
//       expect(find.byType(AppBar), findsOneWidget);
//       expect(find.byType(CustomPaint), findsNWidgets(6));
//       expect(find.byType(GestureDetector), findsOneWidget);
//       expect(find.text(appBarTitle), findsOneWidget);
//     });
//
//     testWidgets('Toggle eraser mode', (WidgetTester tester) async {
//       await tester.pumpWidget(const MaterialApp(home: DrawingBoard()));
//
//       final brushButton = find.byTooltip(eraserLabel);
//       await tester.tap(brushButton);
//       await tester.pump();
//
//       expect(find.byTooltip(brushLabel), findsOneWidget);
//     });
//
//     // Add more widget tests as needed
//   });
// }
