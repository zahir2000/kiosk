import 'package:flutter/material.dart';
import 'package:kiosk/widgets/hands/hands.dart';

import '../../ui/index.dart';

Widget myRow(
    {required String handName,
    required String text,
    required BuildContext context,
    required void Function() onTap,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
  return Row(
    mainAxisAlignment: mainAxisAlignment,
    children: [
      handName == "one"
          ? oneHandWidget()
          : handName == "two"
              ? twoHandWidget()
              : handName == "three"
                  ? threeHandWidget()
                  : handName == "four"
                      ? fourHandWidget()
                      : handName == "five"
                          ? fiveHandWidget()
                          : const Text(""),
      kHorizontalNormalSpace(),
      GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      )
    ],
  );
}
