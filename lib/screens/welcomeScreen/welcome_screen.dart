import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/cart.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
import '../../ui/index.dart';
import '../../utils/index.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with WidgetsBindingObserver {
  final cartController = Get.find<Cart>();
  Timer? timer;
  late AlertDialog alert;

  Future<void> getCartData() async {
    await cartController.getData();
  }


  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      getCartData();
    });

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("dialog_open", 0);
      prefs.setString("current_screen", "welcome_screen");
    });

    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => _onGestureDetected());
    print("welcome_screen initState");
  }

  Future<void>? _onGestureDetected() {
    //print(ModalRoute.of(context)?.settings.name);
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EatTypeScreen()));
    //button.onPressed!();

    // instead of popping the route, just take to previous screen using Navigator
    // create a global variable in [main.dat] to check what page it is currently on.

    if (inferenceResults != null && inferenceResults!.isNotEmpty) {
      for (var result in inferenceResults!['recognitions']) {
        if (result.score > 0.5) {
          SharedPreferences.getInstance().then((prefs) {
            final int dialogOpen = prefs.getInt('dialog_open') ?? 0;
            if (dialogOpen == 0 && result.label == "option1") {//show dialog for one time only
              prefs.setInt("dialog_open", 1);
              showAlertDialog(context);
            }

            if (dialogOpen == 1 && result.label == "back") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open", 0);
              });
            } else if (dialogOpen == 1 && result.label == "thumb") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open", 0);
                timer?.cancel();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EatTypeScreen()));
              });
            }
          });

          //timer?.cancel();
          //Navigator.push(context,
          //    MaterialPageRoute(builder: (_) => const EatTypeScreen()));

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
          prefs.setInt("dialog_open", 0);
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
              MaterialPageRoute(builder: (_) => const EatTypeScreen()));
        });
      },
    );
    // set up the AlertDialog
    alert = AlertDialog(
      title: Text("Start Order"),
      content: Text("Would you like to continue to start order?"),
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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  ElevatedButton button = ElevatedButton(
    child: Text("Button"),
    onPressed: () => print('pressed'),
  );

  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      showLeftBottomIcon: false,
      showRightBottomIcon: false,
      showLeftUpperIcon: false,
      showText: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              kVerticalNormalSpace(),
              Hero(
                tag: "main",
                child: mainPicWidget(
                  width: 45,
                  height: 10,
                ),
              ),
              Text(
                appName,
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                welcome,
                style: TextStyle(
                  color: kErrorColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 7,
                  fontSize: 15.sp,
                ),
              )
            ],
          ),
          kVerticalMediumSpace(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 8.h,
                width: 8.w,
                child: Image.asset(oneHandPic),
              ),
              kHorizontalNormalSpace(),
              GestureDetector(
                onTap: () => Get.to(
                  () => const EatTypeScreen(),
                  transition: Transition.fadeIn,
                ),
                child: Text(
                  startOrder,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
