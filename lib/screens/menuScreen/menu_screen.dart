import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Timer? timer;
  List availableOptions = ["option1", "option2", "option3", "punch"];
  String _selectedOption = "";
  var _nextRoute;

  @override
  void initState() {

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("dialog_open_menu_screen", 0);
      prefs.setString("current_screen", "menu_screen");
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
          bool isAvailableOption = availableOptions.contains(result.label);

          SharedPreferences.getInstance().then((prefs) {
            final int dialogOpen = prefs.getInt('dialog_open_menu_screen') ?? 0;
            if (dialogOpen == 0 && isAvailableOption) {//show dialog for one time only
              prefs.setInt("dialog_open_menu_screen", 1);

              switch(result.label) {
                case "option1":
                  _selectedOption = "Meals";
                  _nextRoute = const MealsSubMenu();
                  break;
                case "option2":
                  _selectedOption = "Sides";
                  _nextRoute = const SidesSubMenu();
                  break;
                case "option3":
                  _selectedOption = "Cold Beverages";
                  _nextRoute = const ColdBeveragesSubMenu();
                  break;
                case "punch":
                  _selectedOption = "Desserts";
                  _nextRoute = const DessertSubMenu();
                  break;
                default:
                  print("Choice error. Please contact the developer.");
              }
              showAlertDialog(context);
            } else if (dialogOpen == 0 && result.label == "back") {
              timer?.cancel();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EatTypeScreen()));
            }

            if (dialogOpen == 1 && result.label == "back") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_menu_screen", 0);
              });
            } else if (dialogOpen == 1 && result.label == "thumb") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_menu_screen", 0);
                timer?.cancel();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => _nextRoute));
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
      title: Text("Menu"),
      content: Text("Would you like to go $_selectedOption?"),
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
      showText: true,
      text: menu,
      child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 0),
        child: SizedBox(
          width: 60.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myRow(
                  handName: "one",
                  text: meals,
                  context: context,
                  onTap: () => Get.to(
                        () => const MealsSubMenu(),
                        transition: Transition.fadeIn,
                        duration: const Duration(
                            milliseconds: transitionMilliseconds),
                      ),
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalSmallSpace(),
              myRow(
                  handName: "two",
                  text: sides,
                  context: context,
                  onTap: () => Get.to(
                        () => const SidesSubMenu(),
                        transition: Transition.fadeIn,
                        duration: const Duration(
                          milliseconds: transitionMilliseconds,
                        ),
                      ),
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalSmallSpace(),
              myRow(
                  handName: "three",
                  text: coldBeverages,
                  context: context,
                  onTap: () => Get.to(
                        () => const ColdBeveragesSubMenu(),
                        transition: Transition.fadeIn,
                        duration: const Duration(
                          milliseconds: transitionMilliseconds,
                        ),
                      ),
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalSmallSpace(),
              myRow(
                  handName: "fist",
                  text: desserts,
                  context: context,
                  onTap: () => Get.to(
                        () => const DessertSubMenu(),
                        transition: Transition.fadeIn,
                        duration: const Duration(
                          milliseconds: transitionMilliseconds,
                        ),
                      ),
                  mainAxisAlignment: MainAxisAlignment.start),
            ],
          ),
        ),
      ),
    );
  }
}
