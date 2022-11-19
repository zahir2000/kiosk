import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

import '../../utils/index.dart';
import '../../widgets/index.dart';

class MealsSubMenu extends StatefulWidget {
  const MealsSubMenu({super.key});

  @override
  State<MealsSubMenu> createState() => _MealsSubMenuState();
}

class _MealsSubMenuState extends State<MealsSubMenu> {
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
