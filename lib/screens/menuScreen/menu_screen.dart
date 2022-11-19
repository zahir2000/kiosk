import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

import '../../utils/index.dart';
import '../../widgets/index.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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
                  handName: "four",
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
