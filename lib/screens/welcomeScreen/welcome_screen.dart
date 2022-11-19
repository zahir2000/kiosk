import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/cart.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/widgets/index.dart';
import 'package:sizer/sizer.dart';

import '../../ui/index.dart';
import '../../utils/index.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final cartController = Get.find<Cart>();
  Future<void> getCartData() async {
    await cartController.getData();
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      getCartData();
    });
  }

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
