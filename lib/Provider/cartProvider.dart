import '../Provider/provider.dart';
import 'package:flutter/material.dart';
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

  void removeCartItem(Product product){
    if(_cart.values.firstWhere((element) => element.id == product.id).quantity >1){
      _cart.update(product.id, (value) => CartItem(
        id: product.id,
        product: product,
        quantity: value.quantity -=1,
      ));
    }
    else{
      _cart.remove(product.id);
    }
    notifyListeners();
  }

  double  totalAmount (){
    double total  = 0 ;
    _cart.forEach((key, value) {
      total += value.quantity * value.product.price ;
    });
    return total ;
  }

  void addCart({required Product product}) {
    if (_cart.containsKey(product.id) ) {
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

  void clearCart(){
    _cart.clear();
    notifyListeners();
  }
}
