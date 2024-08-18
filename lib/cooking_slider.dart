import 'package:flutter/material.dart';
import 'dart:math';

class CookingSlider extends StatefulWidget {
  const CookingSlider({super.key});

  @override
  _CookingSliderState createState() => _CookingSliderState();
}

class _CookingSliderState extends State<CookingSlider>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  bool _isPlaying = true;
  double _indicatorPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
        setState(() {
          _indicatorPosition = _controller?.value ?? 0;
        });
      });
    _startSlider();
  }

  void _startSlider() {
    _controller?.repeat(reverse: true);
  }

  void _stopSlider() {
    setState(() {
      _isPlaying = false;
    });
    _controller?.stop();
    _checkResult();
  }

  void _checkResult() {
    // Define the "perfect" zone
    double perfectStart = 0.65;
    double perfectEnd = 0.75;

    if (_indicatorPosition >= perfectStart &&
        _indicatorPosition <= perfectEnd) {
      // Perfect cook
      print('Perfect!');
    } else {
      // Not perfect
      print('Try again!');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _isPlaying ? _stopSlider : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildSliderBar(),
            _buildIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderBar() {
    return Container(
      width: 300,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomPaint(
        painter: SliderPainter(),
      ),
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      left: 150 -
          12 +
          276 * _indicatorPosition, // 276 to match the inner slider width
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class SliderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    // Define the "perfect" zone
    final double perfectStart = 0.65 * size.width;
    final double perfectEnd = 0.75 * size.width;

    // Draw the perfect zone
    canvas.drawRect(
      Rect.fromLTWH(perfectStart, 0, perfectEnd - perfectStart, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
