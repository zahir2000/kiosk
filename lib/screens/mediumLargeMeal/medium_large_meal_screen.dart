import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/cart.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

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
