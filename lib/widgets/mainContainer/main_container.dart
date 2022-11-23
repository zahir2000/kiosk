import 'dart:isolate';

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
import 'dart:developer';

import 'package:kiosk/utils/tflite/classifier.dart';
import 'package:kiosk/utils/tflite/isolate_utils.dart';

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

  /// Instance of [Classifier]
  Classifier? classifier;

  /// true when inference is ongoing
  bool? predicting;

  /// Instance of [IsolateUtils]
  IsolateUtils? isolateUtils;

  @override
  void initState() {
    super.initState();
    log("Lifecycle: initState");
    initStateAsync();
    //initTensorFlow();
  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);

    // Spawn a new isolate
    isolateUtils = IsolateUtils();
    await isolateUtils!.start();

    // Camera initialization
    getPermissionStatus();

    // Create an instance of classifier to load model and labels
    classifier = Classifier();

    // Initially predicting = false
    predicting = false;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    //log("onNewCameraSelected");
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
        _initializeFutureController = cameraController.initialize().then((_) async {
          // Stream of image passed to [onLatestImageAvailable] callback
          await cameraController.startImageStream(onLatestImageAvailable);

          /// previewSize is size of each image frame captured by controller
          ///
          /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
          //Size previewSize = cameraController.value.previewSize;

          /// previewSize is size of raw input image to the model
          //CameraViewSingleton.inputImageSize = previewSize;

          // the display width of image on screen is
          // same as screenWidth while maintaining the aspectRatio
          Size screenSize = MediaQuery.of(context).size;

          //CameraViewSingleton.screenSize = screenSize;
          //CameraViewSingleton.ratio = screenSize.width / previewSize.height;

          print(_cameraController?.value.aspectRatio);
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

  /*Future<void> runImageClassification(CameraImage cameraImage) async {
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
  } */

  /*Future<void> initTensorFlow() async {
    String? res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );

    log("TFLite Load Status: ${res!}");
  } */

  onLatestImageAvailable(CameraImage cameraImage) async {
    if (classifier!.interpreter != null && classifier!.labels != null) {
      // If previous inference has not completed then return
      if (predicting!) {
        return;
      }

      setState(() {
        predicting = true;
      });

      var uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;

      // Data to be passed to inference isolate
      var isolateData = IsolateData(
          cameraImage, classifier!.interpreter.address, classifier!.labels);

      // We could have simply used the compute method as well however
      // it would be as in-efficient as we need to continuously passing data
      // to another isolate.

      /// perform inference in separate isolate
      inferenceResults = await inference(isolateData);

      List resultsList = inferenceResults!['recognitions'];

      if (resultsList.isNotEmpty) {
        for (var result in resultsList) {
          double score = double.parse(result.score.toString()) * 100;
          _results = "${result.label}: ${(score.toStringAsFixed(2))}%";
        }
      } else {
        _results = "";
      }



      var uiThreadInferenceElapsedTime =
          DateTime.now().millisecondsSinceEpoch - uiThreadTimeStart;

      // pass results to HomeView
      //widget.resultsCallback(inferenceResults["recognitions"]);

      // pass stats to HomeView
      //widget.statsCallback((inferenceResults["stats"] as Stats)
      //  ..totalElapsedTime = uiThreadInferenceElapsedTime);

      // set predicting to false to allow new frames
      if (mounted) {
        setState(() {
          predicting = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolateUtils!.sendPort
        ?.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  void updateResults() {
    recognitions.then((value){
      value?.forEach((element) {
        //print(element);
        //detectionResults = element['label'] + ": " +(element['confidence']*100).toStringAsFixed(2) + "%";
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
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    print("Lifecycle: $state");

    switch (state) {
      case AppLifecycleState.paused:
        //if (_cameraController != null) {
        //  _cameraController?.stopImageStream();
        //}
        break;
      case AppLifecycleState.resumed:
        _cameraController != null ? getPermissionStatus() : null;

        if (!_cameraController!.value.isStreamingImages) {
          await _cameraController?.startImageStream(onLatestImageAvailable);
        }
        break;
      case AppLifecycleState.inactive:
        _cameraController?.dispose();
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    log("Lifecycle: dispose()");
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //log("Called main_container Widget build");
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
                Text(_results),
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
                                //log("CameraController: isInitialized:"
                                    //"${_cameraController!.value.isInitialized}");
                                if (_cameraController!.value.isInitialized) {
                                  return Stack(fit: StackFit.expand, children: [
                                      CameraPreview(_cameraController!)
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
                      child:const Text(""))
                      /*child:Text(_results,
                        style: const TextStyle(color: Colors.black),
                        textDirection: TextDirection.ltr),), */

                  ],
                ),
                //Text(_results),
                widget.child,
              ],
            ),
          ),
          /*FractionallySizedBox(
            widthFactor: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(""),
              ],
            ),
          ),*/
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
                : const Text(""), //_results
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
