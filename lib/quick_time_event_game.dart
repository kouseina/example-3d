import 'package:flutter/material.dart';
import 'dart:async';

class QuickTimeEventGame extends StatefulWidget {
  @override
  _QuickTimeEventGameState createState() => _QuickTimeEventGameState();
}

class _QuickTimeEventGameState extends State<QuickTimeEventGame> {
  double stopperPosition = 0.5; // Initial position (center)
  bool isMovingRight = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startMoving();
  }

  void startMoving() {
    timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        if (isMovingRight) {
          stopperPosition += 0.01;
          if (stopperPosition >= 1.0) {
            isMovingRight = false;
          }
        } else {
          stopperPosition -= 0.01;
          if (stopperPosition <= 0.0) {
            isMovingRight = true;
          }
        }
      });
    });
  }

  void stopMovement() {
    timer?.cancel();
    // Check if the stopper is within the green area
    if (stopperPosition >= 0.4 && stopperPosition <= 0.6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Success!"),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Missed!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 200,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: (200 * stopperPosition) - 10, // Adjusting the position
              bottom: -10,
              child: CustomPaint(
                size: Size(20, 20),
                painter: TrianglePainter(),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: timer?.isActive ?? false ? stopMovement : startMoving,
          child: Text(timer?.isActive ?? false ? "Stop" : "Start"),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width / 2, 0); // Top
    path.lineTo(0, size.height); // Bottom left
    path.lineTo(size.width, size.height); // Bottom right
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
