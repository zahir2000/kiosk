import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/cart.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final cartController = Get.find<Cart>();
  Timer? timer;
  List availableOptions = ["option1", "option2", "option3"];
  String _selectedOption = "";
  var _nextRoute;

  @override
  void initState() {

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("dialog_open_payment_screen", 0);
      //prefs.setString("current_screen", "cold_beverages_sub_menu");
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
            final int dialogOpen = prefs.getInt('dialog_open_payment_screen') ?? 0;
            if (dialogOpen == 0 && isAvailableOption) {//show dialog for one time only
              prefs.setInt("dialog_open_payment_screen", 1);
              if (result.label == "option1") {
                _selectedOption = "Cash";
              } else if (result.label == "option2") {
                _selectedOption = "Apple Pay";
              } else if (result.label == "option3") {
                _selectedOption = "Credit Card";
              }
              showAlertDialog(context);
            } else if (dialogOpen == 0 && result.label == "back") {
              timer?.cancel();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ViewCartScreen()));
            }

            if (dialogOpen == 1 && result.label == "back") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_payment_screen", 0);
              });
            } else if (dialogOpen == 1 && result.label == "thumb") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_payment_screen", 0);
                timer?.cancel();
                confirmPayment();
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
          prefs.setInt("dialog_open_payment_screen", 0);
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
      content: Text("Would you like to pay using $_selectedOption?"),
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

  void confirmPayment() {
    cartController.clearData();
    Get.to(
      () => const OrderConfirmationScreen(),
      transition: Transition.downToUp,
      duration: const Duration(
        milliseconds: transitionMilliseconds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      showLeftBottomIcon: true,
      showRightBottomIcon: false,
      showLeftUpperIcon: true,
      showText: true,
      text: payment,
      child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 0),
        child: SizedBox(
          width: 50.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myRow(
                  handName: "one",
                  text: cash,
                  context: context,
                  onTap: () => {confirmPayment()},
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalSmallSpace(),
              myRow(
                  handName: "two",
                  text: applePay,
                  context: context,
                  onTap: () => {confirmPayment()},
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalSmallSpace(),
              myRow(
                  handName: "three",
                  text: creditCard,
                  context: context,
                  onTap: () => {confirmPayment()},
                  mainAxisAlignment: MainAxisAlignment.start),
            ],
          ),
        ),
      ),
    );
  }
}
