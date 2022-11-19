import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

import '../../utils/index.dart';
import '../../widgets/index.dart';

class DessertSubMenu extends StatefulWidget {
  const DessertSubMenu({super.key});

  @override
  State<DessertSubMenu> createState() => _DessertSubMenuState();
}

class _DessertSubMenuState extends State<DessertSubMenu> {
  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      showLeftBottomIcon: true,
      showRightBottomIcon: true,
      showLeftUpperIcon: true,
      showText: true,
      text: desserts,
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
                  text: donuts,
                  context: context,
                  onTap: () => Get.to(
                        () => const AddToCart(
                          menuCategoryText: desserts,
                          menuTextToAddCart: donuts,
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
                  text: cookies,
                  context: context,
                  onTap: () => Get.to(
                        () => const AddToCart(
                          menuCategoryText: desserts,
                          menuTextToAddCart: cookies,
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
