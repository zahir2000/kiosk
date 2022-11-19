import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/index.dart';

Widget responsiveScreen({
  required Widget child,
  required bool showLeftUpperIcon,
  required bool showRightBottomIcon,
  required bool showLeftBottomIcon,
  bool singleChildScroll = false,
  required bool showText,
  String text = "",
}) {
  return Scaffold(
    body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        if (SizerUtil.orientation == Orientation.portrait) {
          if (singleChildScroll) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: MainContainer(
                showLeftBottomIcon: showLeftBottomIcon,
                showRightBottomIcon: showRightBottomIcon,
                showLeftUpperIcon: showLeftUpperIcon,
                showText: showText,
                text: text,
                child: child,
              ),
            );
          } else {
            return MainContainer(
              showLeftBottomIcon: showLeftBottomIcon,
              showRightBottomIcon: showRightBottomIcon,
              showLeftUpperIcon: showLeftUpperIcon,
              showText: showText,
              // context: context,
              text: text,
              child: child,
            );
          }
        } else {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: MainContainer(
              showLeftBottomIcon: showLeftBottomIcon,
              showRightBottomIcon: showRightBottomIcon,
              showLeftUpperIcon: showLeftUpperIcon,
              showText: showText,
              text: text,
              // context: context,
              child: child,
            ),
          );
        }
      },
    ),
  );
}
