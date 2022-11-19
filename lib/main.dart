import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/cart.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/utils/index.dart';
import 'package:sizer/sizer.dart';

/*late List<CameraDescription> cameras;
late CameraController cameraController;
late Future<void> initializeFutureController;
int selectedCamera = 0;
bool loading = true;
void initializeCamera(int cameraIndex, CameraDescription description) {
  cameraController = CameraController(
    description,
    ResolutionPreset.high,
  );

  initializeFutureController = cameraController.initialize();
  loading = false;
}*/

List<CameraDescription> cameras = [];

Future<void> main() async {
  Get.put(Cart());
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  //initializeCamera(
  //    selectedCamera,
 //     cameras.firstWhere((description) =>
  //        description.lensDirection == CameraLensDirection.front));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: MyTheme.lightTheme,
        home: const WelcomeScreen(),
      ),
    );
  }
}
