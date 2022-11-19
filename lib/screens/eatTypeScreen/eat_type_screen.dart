import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/utils/index.dart';
import 'package:kiosk/widgets/index.dart';
import 'package:sizer/sizer.dart';

import '../../ui/index.dart';

class EatTypeScreen extends StatefulWidget {
  const EatTypeScreen({super.key});

  @override
  State<EatTypeScreen> createState() => _EatTypeScreenState();
}

class _EatTypeScreenState extends State<EatTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      showLeftBottomIcon: true,
      showRightBottomIcon: false,
      showLeftUpperIcon: true,
      showText: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 15.h, 0, 0),
        child: SizedBox(
          width: 50.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myRow(
                  handName: "one",
                  text: dineIn,
                  context: context,
                  onTap: () => Get.to(
                        () => const MenuScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(
                            milliseconds: transitionMilliseconds),
                      ),
                  mainAxisAlignment: MainAxisAlignment.start),
              kVerticalNormalSpace(),
              myRow(
                  handName: "two",
                  text: takeAway,
                  context: context,
                  onTap: () => Get.to(
                        () => const MenuScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(
                            milliseconds: transitionMilliseconds),
                      ),
                  mainAxisAlignment: MainAxisAlignment.start),
            ],
          ),
        ),
      ),
    );
  }
}
