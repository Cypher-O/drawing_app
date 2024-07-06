import 'package:drawing_app/utils/imports/flutter_import.dart';

class Stroke {
  final Color color;
  final double strokeWidth;
  List<Offset> points;
  List<List<Offset>> segments;

  Stroke({
    required this.color,
    required this.strokeWidth,
    required this.points,
  }) : segments = [points];

  void addPoint(Offset point) {
    points.add(point);
    segments.last.add(point);
  }

  void startNewSegment() {
    segments.add([points.last]);
  }
}