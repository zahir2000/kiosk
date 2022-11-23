import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/cart.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
import '../../utils/index.dart';
import '../../widgets/index.dart';

class MediumLargeMeal extends StatefulWidget {
  final String menuCategoryText;
  final String menuTextToAddCart;
  const MediumLargeMeal({
    super.key,
    required this.menuCategoryText,
    required this.menuTextToAddCart,
  });

  @override
  State<MediumLargeMeal> createState() => _MediumLargeMealState();
}

class _MediumLargeMealState extends State<MediumLargeMeal> {
  final cartController = Get.find<Cart>();
  bool colaDrink = true, spriteDrink = false;
  Timer? timer;
  List availableOptions = ["option1", "option2"];

  @override
  void initState() {

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("dialog_open_medium_large_meal_screen", 0);
    });

    Future.delayed(const Duration(seconds: START_DETECTION_DELAY), () {
      timer = Timer.periodic(const Duration(seconds: DETECTION_CHECK_TIMER), (Timer t) => _onGestureDetected());
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void>? _onGestureDetected() {
    if (inferenceResults != null && inferenceResults!.isNotEmpty) {
      for (var result in inferenceResults!['recognitions']) {
        if (result.score > 0.5) {
          bool isAvailableOption = availableOptions.contains(result.label);

          SharedPreferences.getInstance().then((prefs) {
            final int dialogOpen = prefs.getInt('dialog_open_medium_large_meal_screen') ?? 0;
            if (dialogOpen == 0 && isAvailableOption) {//show dialog for one time only
              //prefs.setInt("dialog_open_medium_large_meal_screen", 1);
              if (result.label == "option1") {
                setState(() {
                  colaDrink = true;
                  spriteDrink = false;
                });
              } else if (result.label == "option2") {
                setState(() {
                  colaDrink = false;
                  spriteDrink = true;
                });
              }
              //showAlertDialog(context);
            } else if (dialogOpen == 0 && result.label == "back") {
              timer?.cancel();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MealsSubMenu()));
            } else if (dialogOpen == 0 && result.label == "ok") {
              timer?.cancel();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ViewCartScreen()));
            } else if (dialogOpen == 0 && result.label == "thumb") {
              cartController.addItemToCart(
                itemName: widget.menuTextToAddCart,
                itemCategory: widget.menuCategoryText,
              );
              cartController.addItemToCart(
                itemName: sandwich,
                itemCategory: common,
              );
              cartController.addItemToCart(
                itemName: '$french $fries',
                itemCategory: sides,
              );
              cartController.addItemToCart(
                itemName: colaDrink ? cola : sprite,
                itemCategory: coldBeverages,
              );

              timer?.cancel();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MealsSubMenu()));
            }

            if (dialogOpen == 1 && result.label == "back") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_medium_large_meal_screen", 0);
              });
            } else if (dialogOpen == 1 && result.label == "thumb") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_medium_large_meal_screen", 0);
                timer?.cancel();
              });
            }
          });
        }
      }
    }
    return null;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: SizedBox(
          height: 8.h,
          width: 8.w,
          child: Image.asset(fiveHandPic)),
      onPressed:  () {
        SharedPreferences.getInstance().then((prefs) {
          Navigator.pop(context, false);
          prefs.setInt("dialog_open_medium_large_meal_screen", 0);
        });
      },
    );
    Widget continueButton = ElevatedButton(
      child: SizedBox(
          height: 8.h,
          width: 8.w,
          child: Image.asset(okCartHandPic)),
      onPressed:  () {
        //SharedPreferences.getInstance().then((prefs) {
        //  Navigator.push(context,
        //      MaterialPageRoute(builder: (_) => const MenuScreen()));
        //});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Menu"),
      content: Text("Would you like to add to the cart?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      showLeftBottomIcon: true,
      showRightBottomIcon: true,
      showLeftUpperIcon: true,
      showText: true,
      text: widget.menuCategoryText,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5.h, 0, 0),
        child: SizedBox(
          width: 60.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    widget.menuTextToAddCart,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    sandwich,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    '$french ${fries.toLowerCase()}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              kVerticalSmallSpace(),
              Text(
                '$choose $your $drink:',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                width: 40.w,
                child: Column(
                  children: [
                    Row(
                      children: [
                        myRow(
                          handName: "one",
                          text: cola,
                          context: context,
                          onTap: () {
                            setState(() {
                              colaDrink = true;
                              spriteDrink = false;
                            });
                          },
                        ),
                        colaDrink
                            ? const Icon(
                                Icons.check,
                                color: kTextColor,
                              )
                            : const Text(""),
                      ],
                    ),
                    Row(
                      children: [
                        myRow(
                          handName: "two",
                          text: sprite,
                          context: context,
                          onTap: () {
                            setState(() {
                              colaDrink = false;
                              spriteDrink = true;
                            });
                          },
                        ),
                        spriteDrink
                            ? const Icon(
                                Icons.check,
                                color: kTextColor,
                              )
                            : const Text(""),
                      ],
                    ),
                  ],
                ),
              ),
              kVerticalNormalSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  okCartHandWidget(height: 6, width: 15),
                  kHorizontalNormalSpace(),
                  GestureDetector(
                    onTap: () async {
                      await cartController.addItemToCart(
                        itemName: widget.menuTextToAddCart,
                        itemCategory: widget.menuCategoryText,
                      );
                      await cartController.addItemToCart(
                        itemName: sandwich,
                        itemCategory: common,
                      );
                      await cartController.addItemToCart(
                        itemName: '$french $fries',
                        itemCategory: sides,
                      );
                      await cartController.addItemToCart(
                        itemName: colaDrink ? cola : sprite,
                        itemCategory: coldBeverages,
                      );
                      Get.back();
                    },
                    child: SizedBox(
                      width: 30.w,
                      child: Text(
                        addToCart,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
