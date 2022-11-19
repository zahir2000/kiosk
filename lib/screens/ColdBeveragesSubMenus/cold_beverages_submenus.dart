import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

import '../../utils/index.dart';
import '../../widgets/index.dart';

class ColdBeveragesSubMenu extends StatefulWidget {
  const ColdBeveragesSubMenu({super.key});

  @override
  State<ColdBeveragesSubMenu> createState() => _ColdBeveragesSubMenuState();
}

class _ColdBeveragesSubMenuState extends State<ColdBeveragesSubMenu> {
  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      showLeftBottomIcon: true,
      showRightBottomIcon: true,
      showLeftUpperIcon: true,
      showText: true,
      text: coldBeverages,
      child: Container(
        padding: EdgeInsets.fromLTRB(15.w, 15.h, 0, 0),
        child: SizedBox(
          width: 50.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myRow(
                  handName: "one",
                  text: cola,
                  context: context,
                  onTap: () => Get.to(
                        () => const AddToCart(
                          menuCategoryText: coldBeverages,
                          menuTextToAddCart: cola,
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
                  text: sprite,
                  context: context,
                  onTap: () => Get.to(
                        () => const AddToCart(
                          menuCategoryText: coldBeverages,
                          menuTextToAddCart: sprite,
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
