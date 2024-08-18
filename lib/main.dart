import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:example3d/quick_time_event_game_2.dart';
import 'package:example3d/quick_time_event_game_3.dart';
import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

late List<CameraDescription> _cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late CameraController cameraController;
  O3DController o3dController = O3DController();
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cookingSliderSetup();
    cameraSetup();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
    animationController.dispose();
  }

  void cookingSliderSetup() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void cameraSetup() {
    cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (!cameraController.value.isInitialized)
              Container()
            else
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(cameraController),
              ),
            O3D(
              src: 'assets/fishing_rod.glb',
              controller: o3dController,
              ar: false,
              autoPlay: true,
              autoRotate: false,
              cameraControls: false,
              cameraTarget: CameraTarget(-2, 4, -1.5),
              cameraOrbit: CameraOrbit(100, 90, 0),
            ),
            QuickTimeEventGame3(),
          ],
        ),
      ),
    );
  }
}
