import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

import '../../utils/index.dart';
import '../../widgets/index.dart';

class ChickenBeefBurgerScreen extends StatefulWidget {
  final String burgerText;
  const ChickenBeefBurgerScreen({super.key, required this.burgerText});

  @override
  State<ChickenBeefBurgerScreen> createState() =>
      _ChickenBeefBurgerScreenState();
}

class _ChickenBeefBurgerScreenState extends State<ChickenBeefBurgerScreen> {
  void mediumLargeNavigation(String name) {
    Get.to(
      () => MediumLargeMeal(
        menuCategoryText: widget.burgerText,
        menuTextToAddCart: name,
      ),
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
      text: widget.burgerText,
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
                  text: sandwiches,
                  context: context,
                  onTap: () => Get.to(
                        () => AddToCart(
                          menuCategoryText: widget.burgerText,
                          menuTextToAddCart: sandwich,
                        ),
                        transition: Transition.fadeIn,
                        duration: const Duration(
                          milliseconds: transitionMilliseconds,
                        ),
                      ),
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalSmallSpace(),
              myRow(
                  handName: "two",
                  text: '$medium $meal',
                  context: context,
                  onTap: () => {mediumLargeNavigation('$medium $meal')},
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalSmallSpace(),
              myRow(
                  handName: "three",
                  text: '$large $meal',
                  context: context,
                  onTap: () => {mediumLargeNavigation('$large $meal')},
                  mainAxisAlignment: MainAxisAlignment.start),
            ],
          ),
        ),
      ),
    );
  }
}
