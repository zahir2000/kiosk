import 'dart:convert';

class CartItem {
  String? itemName;
  String? itemCategory;
  int? quantity;

  CartItem(
      {required this.itemName,
      required this.quantity,
      required this.itemCategory});

  CartItem.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    quantity = json['quantity'];
    itemCategory = json['itemCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemName'] = itemName;
    data['quantity'] = quantity;
    data['itemCategory'] = itemCategory;
    return data;
  }

  static Map<String, dynamic> toMap(CartItem cartItem) => {
        'itemName': cartItem.itemName,
        'quantity': cartItem.quantity,
        'itemCategory': cartItem.itemCategory,
      };
  static String encode(List<CartItem> cartItems) => json.encode(
        cartItems
            .map<Map<String, dynamic>>((cartItem) => CartItem.toMap(cartItem))
            .toList(),
      );

  static List<CartItem> decode(String cartItems) =>
      (json.decode(cartItems) as List<dynamic>)
          .map<CartItem>((cartItem) => CartItem.fromJson(cartItem))
          .toList();
}
