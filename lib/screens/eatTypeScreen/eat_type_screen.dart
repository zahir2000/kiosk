import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/utils/index.dart';
import 'package:kiosk/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
import '../../ui/index.dart';

class EatTypeScreen extends StatefulWidget {
  const EatTypeScreen({super.key});

  @override
  State<EatTypeScreen> createState() => _EatTypeScreenState();
}

class _EatTypeScreenState extends State<EatTypeScreen> {
  Timer? timer;
  String _selectedChoice = "";

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("dialog_open_eat_type_screen", 0);
      prefs.setString("current_screen", "eat_type_screen");
    });

    Future.delayed(const Duration(seconds: START_DETECTION_DELAY), () {
      timer = Timer.periodic(const Duration(seconds: DETECTION_CHECK_TIMER), (Timer t) => _onGestureDetected());
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void>? _onGestureDetected() {
    if (inferenceResults != null && inferenceResults!.isNotEmpty) {
      for (var result in inferenceResults!['recognitions']) {
        if (result.score > 0.5) {
          SharedPreferences.getInstance().then((prefs) {
            final int dialogOpen = prefs.getInt('dialog_open_eat_type_screen') ?? 0;
            if (dialogOpen == 0 &&
                (result.label == "option1" || result.label == "option2")) {//show dialog for one time only
              prefs.setInt("dialog_open_eat_type_screen", 1);

              switch(result.label) {
                case "option1": _selectedChoice = "Dine In"; break;
                case "option2": _selectedChoice = "Take Away"; break;
              }

              showAlertDialog(context);
            } else if (dialogOpen == 0 && result.label == "back") {
              timer?.cancel();
              if (Navigator.canPop(context)) {
                Get.to(const WelcomeScreen());
                //Get.back();
              }
              //Navigator.push(context,
              //    MaterialPageRoute(builder: (_) => const WelcomeScreen()));
            }

            if (dialogOpen == 1 && result.label == "back") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_eat_type_screen", 0);
              });
            } else if (dialogOpen == 1 && result.label == "thumb") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_eat_type_screen", 0);
                timer?.cancel();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MenuScreen()));
              });
            }
          });
        }
      }
    }
    return null;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: SizedBox(
          height: 8.h,
          width: 8.w,
          child: Image.asset(fiveHandPic)),
      onPressed:  () {
        SharedPreferences.getInstance().then((prefs) {
          Navigator.pop(context, false);
          prefs.setInt("dialog_open_eat_type_screen", 0);
        });
      },
    );
    Widget continueButton = ElevatedButton(
      child: SizedBox(
          height: 8.h,
          width: 8.w,
          child: Image.asset(okCartHandPic)),
      onPressed:  () {
        SharedPreferences.getInstance().then((prefs) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MenuScreen()));
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Go to Food Menu"),
      content: Text("Would you like to go the $_selectedChoice menu?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      showLeftBottomIcon: true,
      showRightBottomIcon: false,
      showLeftUpperIcon: true,
      showText: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 15.h, 0, 0),
        child: SizedBox(
          width: 50.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myRow(
                  handName: "one",
                  text: dineIn,
                  context: context,
                  onTap: () => Get.to(
                        () => const MenuScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(
                            milliseconds: transitionMilliseconds),
                      ),
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalNormalSpace(),
              myRow(
                  handName: "two",
                  text: takeAway,
                  context: context,
                  onTap: () => Get.to(
                        () => const MenuScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(
                            milliseconds: transitionMilliseconds),
                      ),
                  mainAxisAlignment: MainAxisAlignment.start),
            ],
          ),
        ),
      ),
    );
  }
}
