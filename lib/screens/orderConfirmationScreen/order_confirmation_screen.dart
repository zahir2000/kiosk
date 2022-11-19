import 'package:flutter/material.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

import '../../utils/index.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
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
