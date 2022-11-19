import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/cart.dart';
import 'package:kiosk/screens/index.dart';
import 'package:kiosk/ui/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../utils/index.dart';
import '../../widgets/index.dart';

class ViewCartScreen extends StatefulWidget {
  const ViewCartScreen({super.key});

  @override
  State<ViewCartScreen> createState() => _ViewCartScreenState();
}

class _ViewCartScreenState extends State<ViewCartScreen> {
  final cartController = Get.find<Cart>();
  bool screenBouncing = true, hasOrder = false;
  int numberToBounce = 5;
  void setScreenPhysics() {
    setState(() {
      int count = 0;
      for (var element in cartController.cartItems) {
        if (element.itemCategory == '$beef $burger' ||
            element.itemCategory == '$chicken $burger') {
          count++;
        }
      }
      if (count > 3) {
        numberToBounce = 3;
      }
      screenBouncing = cartController.cartItems.length > numberToBounce;
      hasOrder = cartController.cartItems.isNotEmpty;
    });
  }

  void update() {
    setState(() {});
  }

  void showModal(int quantity, String itemName, int index) {
    showMaterialModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setStateOfModal) => SizedBox(
                  height: 30.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        itemName,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await cartController.decrementItemFromCart(index);
                              setStateOfModal(() {
                                quantity--;
                              });
                              update();
                            },
                            icon: const Icon(
                              Icons.exposure_minus_1,
                            ),
                          ),
                          kHorizontalNormalSpace(),
                          Text(quantity.toString()),
                          kHorizontalNormalSpace(),
                          IconButton(
                            onPressed: () async {
                              await cartController.incrementItemFromCart(index);
                              setStateOfModal(() {
                                quantity++;
                              });
                              update();
                            },
                            icon: const Icon(
                              Icons.plus_one,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )));
  }

  @override
  void initState() {
    super.initState();
    setScreenPhysics();
  }

  @override
  Widget build(BuildContext context) {
    return responsiveScreen(
      singleChildScroll: screenBouncing,
      showLeftBottomIcon: true,
      showRightBottomIcon: false,
      showLeftUpperIcon: true,
      showText: true,
      text: '$your $order',
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, hasOrder ? 10.h : 15.h, 0, 0),
          child: SizedBox(
            width: 80.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: cartController.cartItems.map((i) {
                    int index = cartController.cartItems.indexOf(i);
                    if (i.itemName != '$large $meal' &&
                        i.itemName != '$medium $meal') {
                      return Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${i.quantity} x ${i.itemName}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await cartController
                                      .removeItemFromCart(index);
                                  setScreenPhysics();
                                },
                                child: Text(
                                  delete,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: kErrorColor, fontSize: 12.sp),
                                ),
                              ),
                              kHorizontalNormalSpace(),
                              GestureDetector(
                                onTap: () =>
                                    showModal(i.quantity!, i.itemName!, index),
                                child: Text(
                                  edit,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: kErrorColor, fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${i.quantity} x ${i.itemCategory}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            i.itemName!,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await cartController
                                      .removeItemFromCart(index);
                                  setScreenPhysics();
                                },
                                child: Text(
                                  delete,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: kErrorColor, fontSize: 12.sp),
                                ),
                              ),
                              kHorizontalNormalSpace(),
                              GestureDetector(
                                onTap: () => showModal(i.quantity!,
                                    '${i.itemCategory} ${i.itemName}', index),
                                child: Text(
                                  edit,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: kErrorColor, fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }).toList(),
                ),
                // kVerticalSmallSpace(),
                hasOrder
                    ? myRow(
                        handName: "one",
                        text: '$proceed $to $payment',
                        context: context,
                        onTap: () => Get.to(
                          () => const PaymentScreen(),
                          transition: Transition.downToUp,
                          duration: const Duration(
                            milliseconds: transitionMilliseconds,
                          ),
                        ),
                        mainAxisAlignment: MainAxisAlignment.start,
                      )
                    : Text(
                        '$no $order $yet!',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
