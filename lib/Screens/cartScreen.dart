import 'dart:math';

import 'package:flutter/material.dart';
import 'package:garage/Screens/mainScreen.dart';
import '../Provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final String promoCode = 'jesus is lord';
  double calculatedTotal = 0;
  final user = FirebaseAuth.instance.currentUser;
  final _form = GlobalKey<FormState>();
  bool _loading = false ;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _shoppingCart = Provider.of<CartProvider>(context);
    final _media = MediaQuery.of(context).size.width ;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('Your Cart', style: _theme.textTheme.headline6),
        backgroundColor: _theme.primaryColor,
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(
                  height: _media * 1.40,
                  child: ListView(
                    children: _shoppingCart.cart.values
                        .map((cart) => ListTile(
                              trailing: Container(
                                width: _media * 0.4,
                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _shoppingCart.addCart(
                                            product: cart.product);
                                      },
                                      child: const Icon(Icons.add , color: Colors.orangeAccent,),
                                    ),
                                    Text(cart.quantity.toInt().toString()),
                                    TextButton(
                                      onPressed: () {
                                        _shoppingCart
                                            .removeCartItem(cart.product);
                                      },
                                      child: const Icon(Icons.remove ,  color: Colors.orangeAccent),
                                    ),
                                  ],
                                ),
                              ),
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      cart.product.url,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              title: Text(
                                cart.product.name,
                                style: _theme.textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle:
                                  Text('\$${cart.product.price * cart.quantity}' , style: _theme.textTheme.bodyText2,),
                            ))
                        .followedBy([
                      ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: ' Enter a promo code ',
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                validator: (value) {
                                  if (value != promoCode) {
                                    return 'Enter a valid Promo code';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (_form.currentState!.validate()) {
                                  setState(() {
                                    calculatedTotal =
                                        _shoppingCart.totalAmount() * 0.15;
                                  });
                                }
                              },
                              child: const Text(
                                'apply', style: TextStyle(color: Colors.orangeAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]).toList(),
                  ),
                ),
                SizedBox(height: _media * 0.229,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      calculatedTotal == 0
                          ? Text(
                        'Total :  \$ ${_shoppingCart.totalAmount()}',
                        style: _theme.textTheme.headline6,
                      )
                          : Text(
                        'Total :  \$$calculatedTotal',
                        style: _theme.textTheme.headline6,
                      ),
                    _loading ? CircularProgressIndicator(
                    ): ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loading = true ;
                          });
                        Order.addOrder(order: Order(
                          id: Random(DateTime.now().second).nextInt(100000000).toString(),
                          total: _shoppingCart.totalAmount(),
                          name: user!.displayName!,
                          placedOn: DateTime.now(),
                          product: _shoppingCart.cart.values.toList(),
                        )).then((_){
                          Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
                          _shoppingCart.clearCart();
                          Provider.of<ProductList>(context , listen: false).clearList();
                        }).catchError((e){
                          setState(() {
                            _loading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('order can not be placed !'),
                          ));
                        });
                        },
                        child: const  Text('Order Now'),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
