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

class MealsSubMenu extends StatefulWidget {
  const MealsSubMenu({super.key});

  @override
  State<MealsSubMenu> createState() => _MealsSubMenuState();
}

class _MealsSubMenuState extends State<MealsSubMenu> {
  Timer? timer;
  List availableOptions = ["option1", "option2"];
  String burgerNav = "";

  @override
  void initState() {

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("dialog_open_meals_sub_menu", 0);
      prefs.setString("current_screen", "meals_sub_menu");
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
            final int dialogOpen = prefs.getInt('dialog_open_meals_sub_menu') ?? 0;
            if (dialogOpen == 0 && isAvailableOption) {//show dialog for one time only
              prefs.setInt("dialog_open_meals_sub_menu", 1);
              if (result.label == "option1") {
                burgerNav = '$chicken $burger';
              } else if (result.label == "option2") {
                burgerNav = '$beef $burger';
              }
              showAlertDialog(context);
            } else if (dialogOpen == 0 && result.label == "back") {
              timer?.cancel();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MenuScreen()));
            } else if (dialogOpen == 0 && result.label == "ok") {
              timer?.cancel();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ViewCartScreen()));
            }

            if (dialogOpen == 1 && result.label == "back") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_meals_sub_menu", 0);
              });
            } else if (dialogOpen == 1 && result.label == "thumb") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_meals_sub_menu", 0);
                timer?.cancel();
                burgerNavigation(burgerNav);
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
          prefs.setInt("dialog_open_meals_sub_menu", 0);
        });
      },
    );
    Widget continueButton = ElevatedButton(
      child: SizedBox(
          height: 8.h,
          width: 8.w,
          child: Image.asset(okCartHandPic)),
      onPressed:  () {
        //SharedPreferences.getInstance().then((prefs) {
        //  Navigator.push(context,
        //      MaterialPageRoute(builder: (_) => const MenuScreen()));
        //});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Menu"),
      content: Text("Would you like to add $burgerNav to the cart?"),
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

  void burgerNavigation(String name) {
    Get.to(
      () => ChickenBeefBurgerScreen(burgerText: name),
      transition: Transition.fadeIn,
      duration: const Duration(
        milliseconds: transitionMilliseconds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      showLeftBottomIcon: true,
      showRightBottomIcon: true,
      showLeftUpperIcon: true,
      showText: true,
      text: meals,
      child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 15.h, 0, 0),
        child: SizedBox(
          width: 60.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myRow(
                  handName: "one",
                  text: '$chicken $burger',
                  context: context,
                  onTap: () => {burgerNavigation('$chicken $burger')},
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalSmallSpace(),
              myRow(
                  handName: "two",
                  text: '$beef $burger',
                  context: context,
                  onTap: () => {burgerNavigation('$beef $burger')},
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalSmallSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
