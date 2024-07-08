import 'package:flutter_test/flutter_test.dart';
import 'package:drawing_app/utils/imports/general_import.dart';

void main() {
  group('DrawingBoard Widget', () {
    testWidgets('DrawingBoard renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DrawingBoard()));

      // Verify that the DrawingBoard widget is rendered
      expect(find.byType(DrawingBoard), findsOneWidget);

      // Verify that the AppBar is present
      expect(find.byType(AppBar), findsOneWidget);

      // Verify that CustomPaint widgets are present (multiple instances)
      expect(find.byType(CustomPaint), findsWidgets);

      // Verify that the color palette is present
      expect(find.byType(SlideTransition), findsWidgets);

      // Verify that CustomIconButtons are present
      expect(find.byType(CustomIconButton), findsWidgets);
    });

    testWidgets('DrawingBoard responds to user interactions', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DrawingBoard()));

      // Simulate drawing
      final gesture = await tester.startGesture(const Offset(100, 100));
      await gesture.moveBy(const Offset(10, 10));
      await gesture.up();
      await tester.pump();

      // Find all CustomIconButtons
      final iconButtons = find.byType(CustomIconButton);

      // Tap each CustomIconButton
      for (int i = 0; i < tester.widgetList(iconButtons).length; i++) {
        await tester.tap(iconButtons.at(i));
        await tester.pump();
      }
    });
  });
}