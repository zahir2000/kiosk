import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

import '../../utils/index.dart';
import '../../widgets/index.dart';

class SidesSubMenu extends StatefulWidget {
  const SidesSubMenu({super.key});

  @override
  State<SidesSubMenu> createState() => _SidesSubMenuState();
}

class _SidesSubMenuState extends State<SidesSubMenu> {
  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      showLeftBottomIcon: true,
      showRightBottomIcon: true,
      showLeftUpperIcon: true,
      showText: true,
      text: sides,
      child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 15.h, 0, 0),
        child: SizedBox(
          width: 80.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myRow(
                  handName: "one",
                  text: '$french $fries',
                  context: context,
                  onTap: () => Get.to(
                        () => const AddToCart(
                          menuCategoryText: sides,
                          menuTextToAddCart: '$french $fries',
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
                  text: '$fivePcs $chicken $nuggets',
                  context: context,
                  onTap: () => Get.to(
                        () => const AddToCart(
                          menuCategoryText: sides,
                          menuTextToAddCart: '$fivePcs $chicken $nuggets',
                        ),
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
