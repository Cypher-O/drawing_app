import 'package:drawing_app/utils/imports/general_import.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTickerProvider extends Mock implements TickerProvider {}
void main() {
  group('DrawingBoard Tests', () {
    late BaseModel mockBaseModel;

    setUp(() {
      final mockTickerProvider = MockTickerProvider();
      mockBaseModel = BaseModel(mockTickerProvider);
    });

    testWidgets('Initial state', (WidgetTester tester) async {
      await tester.pumpWidget(ViewModelBuilder<BaseModel>.reactive(
        viewModelBuilder: () => mockBaseModel,
        builder: (context, viewModel, child) => const MaterialApp(home: DrawingBoard()),
      ));

      expect(AppColors.blackColor, equals(Colors.black));
      expect(AppColors.whiteColor, equals(Colors.white));
      expect(strokeWidth, equals(5));
      expect(strokes, isEmpty);
      expect(currentStroke, isNull);
      expect(isEraserMode, isFalse);
    });

    testWidgets('Toggle eraser mode', (WidgetTester tester) async {
      await tester.pumpWidget(ViewModelBuilder<BaseModel>.reactive(
        viewModelBuilder: () => mockBaseModel,
        builder: (context, viewModel, child) => const MaterialApp(home: DrawingBoard()),
      ));

      expect(isEraserMode, isFalse);

      // Find the eraser button and tap it
      final eraserButton = find.widgetWithIcon(IconButton, Iconsax.eraser_1);
      await tester.tap(eraserButton);
      await tester.pump();

      expect(isEraserMode, isTrue);
    });

    testWidgets('Drawing a stroke', (WidgetTester tester) async {
      await tester.pumpWidget(ViewModelBuilder<BaseModel>.reactive(
        viewModelBuilder: () => mockBaseModel,
        builder: (context, viewModel, child) => const MaterialApp(home: DrawingBoard()),
      ));

      // Find the drawing area and perform a drag gesture
      final drawingArea = find.byKey(const Key('drawingArea'));
      await tester.dragFrom(tester.getCenter(drawingArea), const Offset(20, 20));
      await tester.pump();

      expect(strokes, isNotEmpty);
      expect(strokes.first.points, isNotEmpty);
      expect(strokes.first.color, equals(Colors.black));
      expect(strokes.first.strokeWidth, equals(5));
    });

    testWidgets('Clear board', (WidgetTester tester) async {
      await tester.pumpWidget(ViewModelBuilder<BaseModel>.reactive(
        viewModelBuilder: () => mockBaseModel,
        builder: (context, viewModel, child) => const MaterialApp(home: DrawingBoard()),
      ));

      // Draw something
      final drawingArea = find.byKey(const Key('drawingArea'));
      await tester.dragFrom(tester.getCenter(drawingArea), const Offset(20, 20));
      await tester.pump();

      expect(strokes, isNotEmpty);

      // Find the clear board button and tap it
      final clearButton = find.widgetWithIcon(IconButton, Iconsax.trash);
      await tester.tap(clearButton);
      await tester.pump();

      expect(strokes, isEmpty);
    });

    testWidgets('Change stroke color', (WidgetTester tester) async {
      await tester.pumpWidget(ViewModelBuilder<BaseModel>.reactive(
        viewModelBuilder: () => mockBaseModel,
        builder: (context, viewModel, child) => const MaterialApp(home: DrawingBoard()),
      ));

      // Find the red color chooser and tap it
      final redColorChooser = find.byWidgetPredicate((widget) =>
          widget is GestureDetector &&
          widget.child is Container &&
          (widget.child as Container).decoration is BoxDecoration &&
          ((widget.child as Container).decoration as BoxDecoration).color == Colors.red);
      await tester.tap(redColorChooser);
      await tester.pump();

      // Draw something
      final drawingArea = find.byKey(const Key('drawingArea'));
      await tester.dragFrom(tester.getCenter(drawingArea), const Offset(20, 20));
      await tester.pump();

      expect(strokes, isNotEmpty);
      expect(strokes.last.color, equals(Colors.red));
    });

    testWidgets('Change stroke width', (WidgetTester tester) async {
      await tester.pumpWidget(ViewModelBuilder<BaseModel>.reactive(
        viewModelBuilder: () => mockBaseModel,
        builder: (context, viewModel, child) => const MaterialApp(home: DrawingBoard()),
      ));

      // Change stroke width using the slider
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(20, 0)); // Adjust offset as needed
      await tester.pump();

      // Draw something
      final drawingArea = find.byKey(const Key('drawingArea'));
      await tester.dragFrom(tester.getCenter(drawingArea), const Offset(20, 20));
      await tester.pump();

      expect(strokes, isNotEmpty);
      expect(strokes.last.strokeWidth, greaterThan(5));
    });
  });
}




// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:drawing_app/main.dart';

// void main() {
//   group('DrawingBoard', () {
//     testWidgets('Initial state', (WidgetTester tester) async {
//       await tester.pumpWidget(const MaterialApp(home: DrawingBoard()));
      
//       final state = tester.state<DrawingBoardState>(find.byType(DrawingBoard));
//       expect(state.selectedColor, equals(Colors.black));
//       expect(state.selectedBackgroundColor, equals(Colors.white));
//       expect(state.strokeWidth, equals(5));
//       expect(state.strokes, isEmpty);
//       expect(state.currentStroke, isNull);
//       expect(state.isEraserMode, isFalse);
//     });

//     testWidgets('Toggle eraser mode', (WidgetTester tester) async {
//   await tester.pumpWidget(const MaterialApp(home: DrawingBoard()));
  
//   final state = tester.state<DrawingBoardState>(find.byType(DrawingBoard));
//   expect(state.isEraserMode, isFalse);
  
//   // Print all widgets in the tree
//   void printWidgetTree(Widget widget, String indent) {
//     print('$indent${widget.runtimeType}');
//     if (widget is SingleChildRenderObjectWidget) {
//       if (widget.child != null) {
//         printWidgetTree(widget.child!, '$indent  ');
//       }
//     } else if (widget is MultiChildRenderObjectWidget) {
//       widget.children.forEach((child) {
//         printWidgetTree(child, '$indent  ');
//       });
//     }
//   }

//   printWidgetTree(tester.firstWidget(find.byType(MaterialApp)), '');

//   // Try to find the AppBar
//   final appBarFinder = find.byType(AppBar);
//   if (appBarFinder.evaluate().isEmpty) {
//     print('AppBar not found');
//   } else {
//     print('AppBar found');
    
//     // Try to find the eraser button within the AppBar
//     final eraserButton = find.descendant(
//       of: appBarFinder,
//       matching: find.byWidgetPredicate((widget) => 
//         widget is IconButton && 
//         ((widget.icon as Icon).icon == Iconsax.eraser_1 || (widget.icon as Icon).icon == Iconsax.brush_14)
//       )
//     );
    
//     if (eraserButton.evaluate().isEmpty) {
//       print('Eraser button not found within AppBar');
//     } else {
//       print('Eraser button found');
//       await tester.tap(eraserButton);
//       await tester.pump();
      
//       expect(state.isEraserMode, isTrue);
//     }
//   }
// });

//     testWidgets('Drawing a stroke', (WidgetTester tester) async {
//       await tester.pumpWidget(const MaterialApp(home: DrawingBoard()));
      
//       final state = tester.state<DrawingBoardState>(find.byType(DrawingBoard));
      
//       // Find the drawing area and perform a drag gesture
//       final drawingArea = find.byKey(const Key('drawingArea'));
//       await tester.dragFrom(tester.getCenter(drawingArea), const Offset(20, 20));
//       await tester.pump();

//       expect(state.strokes, isNotEmpty);
//       expect(state.strokes.first.points, isNotEmpty);
//       expect(state.strokes.first.color, equals(Colors.black));
//       expect(state.strokes.first.strokeWidth, equals(5));
//     });

//     testWidgets('Clear board', (WidgetTester tester) async {
//       await tester.pumpWidget(const MaterialApp(home: DrawingBoard()));
      
//       final state = tester.state<DrawingBoardState>(find.byType(DrawingBoard));
      
//       // Draw something
//       final drawingArea = find.byKey(const Key('drawingArea'));
//       await tester.dragFrom(tester.getCenter(drawingArea), const Offset(20, 20));
//       await tester.pump();

//       expect(state.strokes, isNotEmpty);

//       // Find the clear board button and tap it
//       final clearButton = find.byWidgetPredicate((widget) => 
//         widget is IconButton && (widget.icon as Icon).icon == Iconsax.trash);
//       await tester.tap(clearButton);
//       await tester.pump();
      
//       expect(state.strokes, isEmpty);
//     });

//     testWidgets('Change stroke color', (WidgetTester tester) async {
//       await tester.pumpWidget(const MaterialApp(home: DrawingBoard()));
      
//       final state = tester.state<DrawingBoardState>(find.byType(DrawingBoard));
      
//       // Find the red color chooser and tap it
//       final redColorChooser = find.byWidgetPredicate((widget) =>
//         widget is GestureDetector &&
//         widget.child is Container &&
//         (widget.child as Container).decoration is BoxDecoration &&
//         ((widget.child as Container).decoration as BoxDecoration).color == Colors.red
//       );
//       await tester.tap(redColorChooser);
//       await tester.pump();
      
//       // Draw something
//       final drawingArea = find.byKey(const Key('drawingArea'));
//       await tester.dragFrom(tester.getCenter(drawingArea), const Offset(20, 20));
//       await tester.pump();

//       expect(state.strokes, isNotEmpty);
//       expect(state.strokes.last.color, equals(Colors.red));
//     });

//     testWidgets('Change stroke width', (WidgetTester tester) async {
//       await tester.pumpWidget(const MaterialApp(home: DrawingBoard()));
      
//       final state = tester.state<DrawingBoardState>(find.byType(DrawingBoard));
      
//       // Change stroke width using the slider
//       final slider = find.byType(Slider);
//       await tester.drag(slider, const Offset(20, 0)); // Adjust offset as needed
//       await tester.pump();
      
//       // Draw something
//       final drawingArea = find.byKey(const Key('drawingArea'));
//       await tester.dragFrom(tester.getCenter(drawingArea), const Offset(20, 20));
//       await tester.pump();

//       expect(state.strokes, isNotEmpty);
//       expect(state.strokes.last.strokeWidth, greaterThan(5));
//     });
//   });
// }