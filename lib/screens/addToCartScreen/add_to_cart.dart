import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/cart.dart';
import 'package:kiosk/ui/index.dart';
import 'package:sizer/sizer.dart';

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
