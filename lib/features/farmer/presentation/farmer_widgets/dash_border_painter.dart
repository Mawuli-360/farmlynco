import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final List<int> dashPattern;

  DashedBorderPainter({
    this.strokeWidth = 2.0,
    this.color = Colors.blue,
    this.dashPattern = const [8, 4],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    double startX = 0.0;
    double startY = 0.0;
    bool drawing = true;

    for (double i = 0.0; i <= size.width; i++) {
      if (drawing) {
        path.moveTo(startX, startY);
        path.lineTo(i, startY);
        startX = i;
      } else {
        startX = i;
      }
      drawing = !drawing;
    }

    for (double i = 0.0; i <= size.height; i++) {
      if (drawing) {
        path.moveTo(startX, startY);
        path.lineTo(startX, i);
        startY = i;
      } else {
        startY = i;
      }
      drawing = !drawing;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
