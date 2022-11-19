import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiosk/utils/index.dart';
import 'package:sizer/sizer.dart';

class MyTheme {
  static ThemeData get lightTheme => ThemeData(
        primaryColor: kPrimaryColor,
        // scaffoldBackgroundColor: kContentColorDarkTheme,
        // appBarTheme: appBarTheme,
        // iconTheme: const IconThemeData(color: kContentColorLightTheme),
        colorScheme: const ColorScheme.light(
          primary: kPrimaryColor,
          // secondary: kSecondaryColor,
          // tertiary: kTertiaryColor,
          background: kPrimaryColor,
          onBackground: kPrimaryColor,
          error: kErrorColor,
        ),
        // floatingActionButtonTheme: const FloatingActionButtonThemeData(
        //   backgroundColor: kPrimaryColor,
        //   splashColor: kSecondaryColor,
        // ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     primary: Colors.black,
        //     onPrimary: Colors.white,
        //     minimumSize: const Size(double.maxFinite, 50),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //   ),
        // ),
        textTheme: TextTheme(
          bodyText1: myBodyText1(kTextColor),
          headline1: myHeadline1(kTextColor),
          headline2: myHeadline2(kTextColor),
        ),
      );

  ///
  // static ThemeData get darkTheme => ThemeData(
  //       primaryColor: kPrimaryColor,
  //       scaffoldBackgroundColor: kContentColorLightTheme,
  //       appBarTheme: appBarTheme,
  //       iconTheme: const IconThemeData(color: kContentColorDarkTheme),
  //       colorScheme: const ColorScheme.dark(
  //         brightness: Brightness.dark,
  //         primary: kPrimaryColor,
  //         secondary: kSecondaryColor,
  //         tertiary: kTertiaryColor,
  //         background: Color(0xFF4D6D95),
  //         onBackground: Colors.blueGrey,
  //         error: kErrorColor,
  //       ),
  //       floatingActionButtonTheme: const FloatingActionButtonThemeData(
  //         backgroundColor: kPrimaryColor,
  //         splashColor: kSecondaryColor,
  //       ),
  //       elevatedButtonTheme: ElevatedButtonThemeData(
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.blueGrey,
  //           onPrimary: Colors.white,
  //           minimumSize: const Size(double.maxFinite, 50),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //       ),
  //       textTheme: TextTheme(
  //         headline4: myHeadline4(Colors.white),
  //         headline5: myHeadline5(Colors.white),
  //       ),
  //     );

  static AppBarTheme appBarTheme = const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    color: Colors.transparent,
  );

  ///

  static TextStyle myHeadline2(Color c) => TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.dosis().fontFamily,
        fontSize: heading2Size.sp,
        color: c,
        height: 0.6,
      );
  static TextStyle myBodyText1(Color c) => TextStyle(
        fontFamily: GoogleFonts.belleza().fontFamily,
        color: c,
        fontSize: text1BodySize.sp,
      );

  static TextStyle myHeadline1(Color c) => TextStyle(
        fontWeight: FontWeight.w900,
        fontFamily: GoogleFonts.dosis().fontFamily,
        color: c,
        fontSize: heading1Size.sp,
      );
}
