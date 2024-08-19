import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class QuickTimeEventGame3 extends StatefulWidget {
  @override
  _QuickTimeEventGame3State createState() => _QuickTimeEventGame3State();
}

class _QuickTimeEventGame3State extends State<QuickTimeEventGame3> {
  final keyLoader = GlobalKey<State>();
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
          stopperPosition += 0.005;
          if (stopperPosition >= 1.0) {
            isMovingRight = false;
          }
        } else {
          stopperPosition -= 0.005;
          if (stopperPosition <= 0.0) {
            isMovingRight = true;
          }
        }
      });
    });
  }

  void listenToGyroscope() {
    _gyroscopeSubscription =
        gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (event.y > 1.5) {
        // Adjust the threshold value based on your needs
        stopMovement();
      }
    });
  }

  void stopMovement() {
    timer?.cancel();
    _gyroscopeSubscription?.cancel();
    // Check if the stopper is within the green area
    if (stopperPosition >= 0.3 && stopperPosition <= 0.7) {
      _successModal(
        context,
        key: keyLoader,
        onClick: () {
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          startMoving();
          listenToGyroscope();
        },
        isSuccess: true,
      );
    } else {
      _successModal(
        context,
        key: keyLoader,
        onClick: () {
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          startMoving();
          listenToGyroscope();
        },
        isSuccess: false,
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 200),
            painter: CurvedBarPainter(stopperPosition),
          ),
        ),
      ],
    );
  }
}

class CurvedBarPainter extends CustomPainter {
  final double stopperPosition;

  CurvedBarPainter(this.stopperPosition);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    Path path = Path();

    // Create the curved bar (mirrored)
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
        size.width * 0.5, size.height - 100, size.width, size.height);

    paint.color = Colors.red;
    canvas.drawPath(path, paint);

    path.reset();
    path.moveTo(size.width * 0.2, size.height);
    path.quadraticBezierTo(
        size.width * 0.5, size.height - 80, size.width * 0.8, size.height);

    paint.color = Colors.yellow;
    canvas.drawPath(path, paint);

    path.reset();
    path.moveTo(size.width * 0.3, size.height);
    path.quadraticBezierTo(
        size.width * 0.5, size.height - 60, size.width * 0.7, size.height);

    paint.color = Colors.green;
    canvas.drawPath(path, paint);

    // Draw the stopper
    Paint stopperPaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    double stopperX = size.width * stopperPosition;

    canvas.drawCircle(Offset(stopperX, size.height - 50), 15, stopperPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void _successModal(
  BuildContext context, {
  required GlobalKey key,
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
            key: key,
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
