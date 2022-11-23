import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
import '../../utils/index.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  Timer? timer;

  @override
  void initState() {
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
        if (result.score > 0.5 && result.label == "back") {
          timer?.cancel();
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()));
        }


      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      showLeftBottomIcon: true,
      showRightBottomIcon: false,
      showLeftUpperIcon: true,
      showText: false,
      text: confirmation,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
        child: SizedBox(
          width: 70.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$order $confirmation',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: kErrorColor,
                    ),
              ),
              kVerticalMediumSpace(),
              Text(
                orderConfirmationMessage,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: kErrorColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
