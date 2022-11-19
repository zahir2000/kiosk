import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/cart.dart';
import 'package:kiosk/main.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:kiosk/utils/index.dart';
import 'package:kiosk/widgets/index.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';
import 'dart:developer';

class MainContainer extends StatefulWidget {
  final Widget child;
  final bool showLeftUpperIcon;
  final bool showRightBottomIcon;
  final bool showLeftBottomIcon;
  final bool showText;
  String text = "";
  MainContainer({
    super.key,
    required this.child,
    required this.showLeftUpperIcon,
    required this.showRightBottomIcon,
    required this.showLeftBottomIcon,
    required this.showText,
    this.text = "",
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> with WidgetsBindingObserver {
  CameraController? _cameraController;
  late Future<void> _initializeFutureController;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
  int selectedCamera = 0;
  bool loading = true;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  int _imageCount = 0;
  int _noOfCameras = 0;
  late Future<List<dynamic>?> recognitions;
  String _results = "";

  @override
  void initState() {
    super.initState();
    log("Lifecycle: initState");
    getPermissionStatus();
    initTensorFlow();
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    log("onNewCameraSelected");
    final previousCameraController = _cameraController;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await previousCameraController?.dispose();

    //resetCameraValues();

    if (mounted) {
      setState(() {
        _cameraController = cameraController;
      });
    }

    // Update UI if controller updated
    //cameraController.addListener(() {
    //  if (mounted) setState(() {});
    //});

    log("onNewCameraSelected: isCameraInitialized: $_isCameraInitialized");

    if (!_isCameraInitialized) {
      try {
        _initializeFutureController = cameraController.initialize().then((value){
          cameraController.startImageStream((image){
            //const oneSec = Duration(seconds: 10);
            //Timer.periodic(oneSec, (Timer t){
            _imageCount++;

            if (_imageCount % 80 == 0) {
              _imageCount = 0;
              runImageClassification(image);
            }
            //});
          });

          if (!mounted) {
            return;
          }

          setState(() {});
        });
        loading = false;
      } on CameraException catch (e) {
        print('Error initializing camera: $e');
      }
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = _cameraController!.value.isInitialized;
      });
    }
  }

  Future<void> runImageClassification(CameraImage cameraImage) async {
    //to preprocess the image

    /*recognitions = Tflite.runModelOnFrame(
      bytesList: cameraImage.planes.map((plane) {return plane.bytes;}).toList(),// required
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      numResults: 1,      // defaults to 5
    ); */

    recognitions = Tflite.detectObjectOnFrame(
        bytesList: cameraImage.planes.map((plane) {return plane.bytes;}).toList(),// required
        model: "SSDMobileNet",
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 127.5,   // defaults to 127.5
        imageStd: 127.5,    // defaults to 127.5
        rotation: 90,       // defaults to 90, Android only
        numResultsPerClass: 2,      // defaults to 5
        threshold: 0.1,     // defaults to 0.1
        asynch: true        // defaults to true
    );

     recognitions.then((value){
      value?.forEach((element) {
        log(element['detectedClass'] + ': ' + element['confidenceInClass'].toString());
      });
    });

    /*
    * .then((recognitions){
      recognitions?.forEach((element) {
        print(element['label'] + ' with ' + (element['confidence']*100).toStringAsFixed(2));
      });
    });*/

    //setState(() {
      //updateResults();
    //});
  }

  Future<void> initTensorFlow() async {
    String? res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );

    log("TFLite Load Status: ${res!}");
  }

  void updateResults() {
    recognitions.then((value){
      value?.forEach((element) {
        //print(element);
        _results = element['label'] + ": " +(element['confidence']*100).toStringAsFixed(2) + "%";
      });
    });
  }

  getPermissionStatus() async {
    log("Called getPermissionStatus");
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      _noOfCameras = cameras.length;
      log("Number of Available Cameras: $_noOfCameras");
      if (_noOfCameras == 1) {
        onNewCameraSelected(cameras[0]);
      } else if (_noOfCameras > 1) {
        onNewCameraSelected(cameras[1]);
      } else {
        log('Camera not found.');
      }

      //refreshAlreadyCapturedImages();
    } else {
      log('Camera Permission: DENIED');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("didChangeAppLifecycleState: $state");
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController?.dispose();
    loading = true;
    log("Lifecycle: dispose()");
  }

  @override
  Widget build(BuildContext context) {
    log("Called main_container Widget build");
    final cartController = Get.find<Cart>();
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 0, 5, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 15.h, 0, 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 15.w,
                        child: widget.showText
                            ? widget.text.split(" ").length == 1
                                ? Text(
                                    widget.text,
                                    style: (widget.text == menu ||
                                            widget.text == meals)
                                        ? Theme.of(context).textTheme.headline2
                                        : Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(color: kErrorColor),
                                  )
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                        Text(
                                          widget.text.split(" ")[0],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .copyWith(
                                                color: kErrorColor,
                                              ),
                                        ),
                                        Text(
                                          widget.text.split(" ")[1],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .copyWith(
                                                  color: kErrorColor,
                                                  fontSize:
                                                      (heading2Size - 2).sp,
                                                  height: 1),
                                        ),
                                      ])
                            : const Text("")),
                    SizedBox(
                      width: 50.w,
                      height: 20.h,
                      child: !loading
                          ? FutureBuilder(
                              future: _initializeFutureController,
                              builder: (context, snapshot) {
                                log("CameraController: isInitialized:"
                                    "${_cameraController!.value.isInitialized}");
                                if (_cameraController!.value.isInitialized) {
                                  return Stack(fit: StackFit.expand, children: [
                                    CameraPreview(_cameraController!),
                                  ]);
                                } else {
                                  // Otherwise, display a loading indicator.
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            )
                          : Image.asset(
                              recPic,
                            ),
                    ),
                    SizedBox(width: 15.w,
                      child:Text(_results,
                        style: const TextStyle(color: Colors.white),
                        textDirection: TextDirection.ltr),),
                  ],
                ),
                widget.child
              ],
            ),
          ),
          Positioned(
              left: 0,
              top: 0,
              child: widget.showLeftUpperIcon
                  ? Hero(
                      tag: "main", child: mainPicWidget(width: 15, height: 20))
                  : const Text("")),
          Positioned(
            right: 0,
            bottom: 0,
            child: widget.showRightBottomIcon
                ? GestureDetector(
                    onTap: () {
                      Get.to(() => const ViewCartScreen(),
                          transition: Transition.downToUp,
                          duration: const Duration(
                            milliseconds: transitionMilliseconds,
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        okHandWidget(width: 12, height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
                              child: Container(
                                width: 5.w,
                                height: 2.h,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: kErrorColor,
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(
                                    () => Text(
                                      cartController.cartItems.length
                                          .toString(),
                                      style: TextStyle(
                                        color: kErrorColor,
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            cartWidget(height: 7, width: 15),
                            Text(viewCart,
                                style: Theme.of(context).textTheme.bodyText1)
                          ],
                        )
                      ],
                    ),
                  )
                : const Text(""),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: widget.showLeftBottomIcon
                ? GestureDetector(
                    onTap: () => {
                      if (widget.text != confirmation)
                        {Get.back()}
                      else
                        {
                          Get.offAll(() => const WelcomeScreen(),
                              transition: Transition.fadeIn,
                              duration: const Duration(
                                  milliseconds: transitionMilliseconds))
                        }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        fiveHandWidget(),
                        kHorizontalNormalSpace(),
                        Text(back, style: Theme.of(context).textTheme.bodyText1)
                      ],
                    ),
                  )
                : const Text(""),
          ),
        ],
      ),
    );
  }
}