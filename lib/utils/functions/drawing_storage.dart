import 'package:drawing_app/utils/imports/general_import.dart';

class DrawingStorage {
  static const String _key = 'user_drawing';
  static const String _keyBackgroundColor = 'background_color';

  static Future<void> saveDrawing(List<Stroke> strokes) async {
    final prefs = await SharedPreferences.getInstance();
    final strokesJson = strokes.map((stroke) => stroke.toJson()).toList();
    final strokesJsonString = json.encode(strokesJson);
    await prefs.setString(_key, strokesJsonString);
  }

  static Future<List<Stroke>> loadDrawing() async {
    final prefs = await SharedPreferences.getInstance();
    final strokesJsonString = prefs.getString(_key);
    if (strokesJsonString == null) {
      return [];
    }
    final strokesJson = json.decode(strokesJsonString) as List;
    return strokesJson
        .map((strokeJson) => Stroke.fromJson(strokeJson))
        .toList();
  }

  static Future<void> clearSavedDrawing() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<bool> hasSavedDrawing() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }

  static Future<void> saveBackgroundColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyBackgroundColor, color.value);
  }

  static Future<Color> loadBackgroundColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_keyBackgroundColor);
    if (colorValue == null) {
      return Colors.white; // Default background color
    }
    return Color(colorValue);
  }

  static Future<void> clearBackgroundColor() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBackgroundColor);
  }
}
