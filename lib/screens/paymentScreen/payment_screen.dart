import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/cart.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

import '../../utils/index.dart';
import '../../widgets/index.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final cartController = Get.find<Cart>();
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
