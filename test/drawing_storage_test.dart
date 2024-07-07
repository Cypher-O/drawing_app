import 'package:drawing_app/utils/imports/general_import.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'mock_classes.mocks.dart'; // Import the generated mocks

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
  });

  group('DrawingStorage Tests', () {
    test('Save and Load Drawing', () async {
      // Mock SharedPreferences instance
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // Create dummy strokes
      List<Stroke> strokes = [Stroke(points: [Offset(0, 0)], color: Colors.black, strokeWidth: 2.0, )];

      // Save strokes
      await DrawingStorage.saveDrawing(strokes);

      // Verify that data was saved
      final savedData = prefs.getString('user_drawing');
      final decodedData = json.decode(savedData!);
      expect(decodedData, strokes.map((s) => s.toJson()).toList());

      // Load strokes
      final loadedStrokes = await DrawingStorage.loadDrawing();
      expect(loadedStrokes.length, strokes.length);
    });

    test('Save and Load Background Color', () async {
      // Mock SharedPreferences instance
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // Create dummy color
      Color backgroundColor = Colors.blue;

      // Save background color
      await DrawingStorage.saveBackgroundColor(backgroundColor);

      // Verify that data was saved
      final savedColor = prefs.getString('background_color');
      expect(savedColor, backgroundColor.value.toString());

      // Load background color
      final loadedColor = await DrawingStorage.loadBackgroundColor();
      expect(loadedColor, backgroundColor);
    });
  });
}
