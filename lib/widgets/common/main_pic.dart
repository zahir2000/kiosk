import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/index.dart';

Widget mainPicWidget({double height = 0, double width = 8}) => SizedBox(
      height: height.h,
      width: width.w,
      child: Image.asset(mainPic),
    );
