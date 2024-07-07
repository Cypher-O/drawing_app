import 'package:drawing_app/utils/imports/general_import.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'mock_classes.mocks.dart'; // Import the generated mocks

class MockTickerProvider extends Mock implements TickerProvider {}

@GenerateMocks([SharedPreferences])
void main() {
  late BaseModel baseModel;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    baseModel = BaseModel(MockTickerProvider());
  });

  group('BaseModel Tests', () {
    test('Save and Load Drawing with Background Color', () async {
      // Mock saving data
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      // Create dummy strokes and color
      List<Stroke> strokes = [Stroke(points: [const Offset(0, 0)], color: Colors.black, strokeWidth: 2.0, )];
      Color backgroundColor = Colors.blue;

      // Save strokes and background color
      await baseModel.saveDrawing();

      // Verify that data was saved
      verify(mockSharedPreferences.setString(
          'user_drawing', json.encode(strokes.map((s) => s.toJson()).toList()))).called(1);
      verify(mockSharedPreferences.setString(
          'background_color', backgroundColor.value.toString())).called(1);

      // Mock loading data
      when(mockSharedPreferences.getString('user_drawing'))
          .thenReturn(json.encode(strokes.map((s) => s.toJson()).toList()));
      when(mockSharedPreferences.getString('background_color'))
          .thenReturn(backgroundColor.value.toString());

      // Load strokes and background color
      await baseModel.loadDrawing();

      // Verify that data was loaded
      expect(strokes.length, strokes.length);
      expect(backgroundColor, backgroundColor);
    });
  });
}
