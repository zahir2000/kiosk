import 'package:get/get.dart';
import 'package:kiosk/models/cart_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  late SharedPreferences prefs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await initialize();
  }

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> addItemToCart(
      {required String itemName, required String itemCategory}) async {
    bool found = false;
    for (CartItem element in cartItems) {
      if (element.itemName == itemName &&
          element.itemCategory == itemCategory) {
        element.quantity = element.quantity! + 1;
        found = true;
      }
      // else if (element.itemCategory == '$chicken $burger' &&
      //     (itemName == itemName || itemName == '$medium $meals')) {
      //   print("CHICKEN");
      //   element.quantity = element.quantity! + 1;
      //   found = true;
      // } else if (element.itemCategory == '$beef $burger' &&
      //     (itemName == '$large $meals' || itemName == '$medium $meals')) {
      //   print("BEEF");
      //   element.quantity = element.quantity! + 1;
      //   found = true;
      // }
    }

    if (!found) {
      CartItem cartItem =
          CartItem(itemName: itemName, quantity: 1, itemCategory: itemCategory);
      cartItems.add(cartItem);
    }
    await saveData();
  }

  Future<void> removeItemFromCart(int index) async {
    cartItems.removeAt(index);
    await saveData();
  }

  Future<void> incrementItemFromCart(int index) async {
    cartItems[index].quantity = cartItems[index].quantity! + 1;
    await saveData();
  }

  Future<void> decrementItemFromCart(int index) async {
    if (cartItems[index].quantity != 0) {
      cartItems[index].quantity = cartItems[index].quantity! - 1;
      await saveData();
    }
  }

  Future<void> saveData() async {
    final String encodedData = CartItem.encode(cartItems);
    await prefs.setString('cartItems', encodedData);
  }

  Future<void> getData() async {
    String? cartItemsString = (prefs.getString('cartItems') ?? "");
    if (cartItemsString.isNotEmpty) {
      final List<CartItem> cItem = CartItem.decode(cartItemsString);
      cartItems.assignAll(cItem);
    }
  }

  void showData() {
    for (var element in cartItems) {
      print('${element.itemName}--${element.quantity}');
    }
  }

  void clearData() async {
    await prefs.remove("cartItems");
    cartItems.assignAll([]);
  }
}
