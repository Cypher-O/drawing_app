import 'package:drawing_app/utils/imports/general_import.dart';

class DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;
  final Stroke? currentStroke;
  final Color backgroundColor;
  final bool isEraserMode;
  final Offset? currentPosition;

  DrawingPainter(
    this.strokes,
    this.currentStroke,
    this.backgroundColor,
    this.isEraserMode,
    this.currentPosition,
  );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(
      backgroundColor,
      BlendMode.srcOver,
    );

    for (var stroke in [
      ...strokes,
      if (currentStroke != null) currentStroke!
    ]) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (var segment in stroke.segments) {
        if (segment.length > 1) {
          final path = Path();
          path.moveTo(
            segment.first.dx,
            segment.first.dy,
          );
          for (int i = 1; i < segment.length; i++) {
            path.lineTo(
              segment[i].dx,
              segment[i].dy,
            );
          }
          canvas.drawPath(
            path,
            paint,
          );
        }
      }
    }

    if (isEraserMode && currentPosition != null) {
      final eraserPaint = Paint()
        ..color = Colors.red.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(
        currentPosition!,
        20,
        eraserPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
