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

    Map<String, dynamic> toJson() {
    return {
      'color': color.value,
      'strokeWidth': strokeWidth,
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
      'segments': segments.map((segment) => 
        segment.map((p) => {'x': p.dx, 'y': p.dy}).toList()
      ).toList(),
    };
  }

  factory Stroke.fromJson(Map<String, dynamic> json) {
    return Stroke(
      color: Color(json['color']),
      strokeWidth: json['strokeWidth'],
      points: (json['points'] as List).map((p) => Offset(p['x'], p['y'])).toList(),
    )..segments = (json['segments'] as List).map((segment) => 
      (segment as List).map((p) => Offset(p['x'], p['y'])).toList()
    ).toList();
  }
}
