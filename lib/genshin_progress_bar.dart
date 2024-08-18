import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class GenshinStyleProgressBar extends StatefulWidget {
  @override
  _GenshinStyleProgressBarState createState() =>
      _GenshinStyleProgressBarState();
}

class _GenshinStyleProgressBarState extends State<GenshinStyleProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    final value = _controller.value;
    if (value > 0.7 && value < 0.9) {
      log("Perfect Cook!");
    } else {
      log("Failed Cook!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(300, 100),
            painter: GenshinStylePainter(),
          ),
          Positioned(
            child: CustomPaint(
              size: Size(280, 50),
              painter: ProgressBarPainter(_controller),
            ),
          ),
        ],
      ),
    );
  }
}

class GenshinStylePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blueGrey[900]!
      ..style = PaintingStyle.fill;

    Paint gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blueGrey[800]!, Colors.grey[800]!],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw the decorative background shape
    Path path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.5, 0, size.width, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.5, size.height, 0, size.height * 0.5)
      ..close();

    canvas.drawPath(path, gradientPaint);

    // Adding some decorative ornaments
    paint.color = Colors.white.withOpacity(0.3);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.5), 10, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.5), 10, paint);

    // Draw additional embellishments here
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ProgressBarPainter extends CustomPainter {
  final Animation<double> animation;

  ProgressBarPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    Paint perfectZonePaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height / 2;

    // Draw the background line
    canvas.drawLine(Offset(0, height), Offset(width, height), backgroundPaint);

    // Draw the perfect zone
    final perfectStart = width * 0.7;
    final perfectEnd = width * 0.9;
    canvas.drawLine(Offset(perfectStart, height), Offset(perfectEnd, height),
        perfectZonePaint);

    // Draw the moving progress bar
    final progressX = width * animation.value;
    canvas.drawLine(
        Offset(progressX, height), Offset(progressX, height), progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
