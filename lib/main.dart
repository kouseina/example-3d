import 'package:camera/camera.dart';
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

class _MyAppState extends State<MyApp> {
  late CameraController cameraController;
  O3DController o3dController = O3DController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cameraSetup();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
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
          ],
        ),
      ),
    );
  }
}
