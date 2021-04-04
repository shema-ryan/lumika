import 'package:flutter/cupertino.dart';
import '../Provider/provider.dart';

class CartItem {
  final String id;
  final Product product;
  double quantity;
  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _cart = {};
  Map<String, CartItem> get cart {
    return {..._cart};
  }

  void addCart({required Product product}) {
    if (_cart.containsKey(product.id)) {
      _cart.update(
          product.id,
          (value) => CartItem(
                quantity: value.quantity += 1,
                id: product.id,
                product: product,
              ));
    } else {
      _cart.putIfAbsent(
          product.id,
          () => CartItem(
                id: product.id,
                product: product,
                quantity: 1,
              ));
    }
    notifyListeners();
  }
}
