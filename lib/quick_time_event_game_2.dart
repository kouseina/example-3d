import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

class QuickTimeEventGame2 extends StatefulWidget {
  @override
  _QuickTimeEventGame2State createState() => _QuickTimeEventGame2State();
}

class _QuickTimeEventGame2State extends State<QuickTimeEventGame2> {
  final modalKey = GlobalKey<State>();
  double stopperPosition = 0.5; // Initial position (center)
  bool isMovingRight = true;
  Timer? timer;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
    startMoving();
    listenToGyroscope();
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
    _gyroscopeSubscription?.cancel();
    // Check if the stopper is within the green area
    if (stopperPosition >= 0.4 && stopperPosition <= 0.6) {
      _successModal(
        context,
        onClick: () {
          Navigator.of(context).pop();
          startMoving();
          listenToGyroscope();
        },
        isSuccess: true,
      );
    } else {
      _successModal(
        context,
        onClick: () {
          Navigator.of(context).pop();
          startMoving();
          listenToGyroscope();
        },
        isSuccess: false,
      );
    }
  }

  void listenToGyroscope() {
    _gyroscopeSubscription =
        gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (event.x > 1.5) {
        // Adjust the threshold value based on your needs
        stopMovement();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
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

void _successModal(
  BuildContext context, {
  required void Function() onClick,
  required bool isSuccess,
}) {
  showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(isSuccess ? "Success" : "Failed"),
                ElevatedButton(
                  onPressed: onClick,
                  child: Text("Start"),
                ),
              ],
            ),
          ),
        );
      });
}
