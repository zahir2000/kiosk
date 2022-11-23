# Hand Gesture-based Food Kiosk Mobile Application
![License: MIT](https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge) ![Flutter](https://img.shields.io/badge/Flutter-%23FF6F00.svg?style=for-the-badge&logo=Flutter&logoColor=53c5f9&color=00579c) ![Android](https://img.shields.io/badge/Android-%23FF6F00.svg?style=for-the-badge&logo=Android&logoColor=31de84&color=000)
## Prerequisites
- [Android Studio](https://developer.android.com/studio) (for Android) (2021.2.1 Patch 1 & 2021.3.1 Patch 1)
- Android SDK (API 28 or above) - use SDK Platforms in Android Studio
- Android SDK Command-line Tools - use SDK Tools in Android Studio
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.3.8) - make sure no issues found on `flutter doctor`
- ~Xcode (for iOS)~ _untested_

## Instruction for Android
1. Clone the [project](https://github.com/zahir2000/kiosk) in Android Studio
2. Start an Emulator (SDK 30 and above preferred)
3. Navigate to `pubspec.yaml` and run `Pub get` command
4. Wait until the dependancies are installed
5. Navigate to `External Libraries/Flutter Plugins/tflite_flutter_helper-0.3.1/android/src.main/kotlin.com.tfliteflutter.tflite_flutter_helper/TfliteFlutterHelperPlugin.kt` **or** copy paste the modified file contents from [here](https://gist.github.com/zahir2000/e4664d10c6046d723f30a1b1960569f7) - skip to `Step 7` if you copy-pasted
6. Go to `line 143` and remove all the question marks `?` from the `onRequestPermissionsResult` function parameters
7. Allow to modify the project files if it asks
8. Run the project and accept permissions it asks

## Additional Information
- If you want to enable your webcam for the emulator: [Android: How to use webcam in emulator?](https://stackoverflow.com/a/30792615/8388315)
- In some cases, the camera preview will show as rotated. Try to move your hand around if that's the case because I did not perform image augmentation to consider cases from different angles
- To try out different models available, navigate to the project folder: `assets/tflite/` and rename any model to `model.tflite` to replace the current model. Default is **EfficientNet-Lite0**
- The gesture detection rate is set to every **3** seconds; to note: only the **Lite[0-1]** models infer in less than 3 seconds. You may change the timer from `DETECTION_CHECK_TIMER` inside `main.dart`

## Demo
![demo](https://i.imgur.com/RcdueVb.gif)

> Zahiriddin Rustamov
