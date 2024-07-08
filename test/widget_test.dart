
import 'package:flutter_test/flutter_test.dart';
import 'package:drawing_app/utils/imports/general_import.dart';

void main() {
  group('CustomIconButton', () {
    testWidgets('renders correctly with all properties', (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomIconButton(
              icon: Icons.add,
              onPressed: () {
                buttonPressed = true;
              },
              tooltip: 'Add',
              size: 24,
              color: Colors.blue,
            ),
          ),
        ),
      );

      // Verify that the CustomIconButton is rendered
      expect(find.byType(CustomIconButton), findsOneWidget);

      // Verify that the IconButton is rendered within CustomIconButton
      expect(find.byType(IconButton), findsOneWidget);

      // Verify icon properties
      final iconFinder = find.byIcon(Icons.add);
      expect(iconFinder, findsOneWidget);
      
      final Icon icon = tester.widget<Icon>(iconFinder);
      expect(icon.size, 24);
      expect(icon.color, Colors.blue);

      // Verify tooltip
      expect(find.byTooltip('Add'), findsOneWidget);

      // Test onPressed callback
      await tester.tap(find.byType(CustomIconButton));
      expect(buttonPressed, isTrue);
    });

    testWidgets('renders correctly with minimal properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomIconButton(
              icon: Icons.close,
            ),
          ),
        ),
      );

      // Verify that the CustomIconButton is rendered
      expect(find.byType(CustomIconButton), findsOneWidget);

      // Verify icon
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Verify default size
      final Icon icon = tester.widget<Icon>(find.byIcon(Icons.close));
      expect(icon.size, 18);

      // Verify no tooltip
      expect(find.byTooltip('Add'), findsNothing);
    });
  });
}