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

class AddToCart extends StatefulWidget {
  final String menuCategoryText;
  final String menuTextToAddCart;
  const AddToCart({
    super.key,
    required this.menuCategoryText,
    required this.menuTextToAddCart,
  });

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  final cartController = Get.find<Cart>();
  Timer? timer;

  @override
  void initState() {

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("dialog_open_add_to_cart", 0);
      print("Current Screen: ${prefs.getString("current_screen")}");
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
          SharedPreferences.getInstance().then((prefs) {
            final int dialogOpen = prefs.getInt('dialog_open_add_to_cart') ?? 0;
            if (dialogOpen == 0 && result.label == "thumb") {//show dialog for one time only
              prefs.setInt("dialog_open_add_to_cart", 1);
              showAlertDialog(context);
            } else if (dialogOpen == 0 && result.label == "back") {
              timer?.cancel();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MenuScreen()));
            } else if (dialogOpen == 0 && result.label == "ok") {
              timer?.cancel();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ViewCartScreen()));
            }

            if (dialogOpen == 1 && result.label == "back") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_add_to_cart", 0);
              });
            } else if (dialogOpen == 1 && result.label == "thumb") {
              SharedPreferences.getInstance().then((prefs) {
                Navigator.pop(context, false);
                prefs.setInt("dialog_open_add_to_cart", 0);

                cartController.addItemToCart(
                  itemName: widget.menuTextToAddCart,
                  itemCategory: widget.menuTextToAddCart == sandwich
                      ? common
                      : widget.menuCategoryText,
                );

                timer?.cancel();

                StatefulWidget route = const ViewCartScreen();
                String? currentScreen = prefs.getString("current_screen");
                switch (currentScreen) {
                  case "dessert_sub_menu":
                    route = const DessertSubMenu();
                    break;
                  case "meals_sub_menu":
                    route = const MealsSubMenu();
                    break;
                  case "sides_sub_menu":
                    route = const SidesSubMenu();
                    break;
                  case "cold_beverages_sub_menu":
                    route = const ColdBeveragesSubMenu();
                    break;
                }

                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => route));
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
          prefs.setInt("dialog_open_add_to_cart", 0);
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
      content: Text("Would you like to add ${widget.menuTextToAddCart} to the cart?"),
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
        padding: EdgeInsets.fromLTRB(0, 18.h, 0, 0),
        child: SizedBox(
          width: 60.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.menuTextToAddCart,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              kVerticalMediumSpace(),
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
                        itemCategory: widget.menuTextToAddCart == sandwich
                            ? common
                            : widget.menuCategoryText,
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
