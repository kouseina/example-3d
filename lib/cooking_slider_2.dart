import 'dart:developer';

import 'package:flutter/material.dart';

class CookingSlider2Painter extends CustomPainter {
  final Animation<double> animation;

  CookingSlider2Painter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final perfectZonePaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height / 2;

    // Draw the background line
    canvas.drawLine(Offset(0, height), Offset(width + 20, height), paint);

    // Draw the perfect zone
    final perfectStart = width * 0.7;
    final perfectEnd = width * 0.9;
    canvas.drawLine(Offset(perfectStart, height), Offset(perfectEnd, height),
        perfectZonePaint);

    // Draw the moving progress bar
    final progressX = width * animation.value;
    canvas.drawLine(Offset(progressX, height), Offset(progressX + 20, height),
        progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
