import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garage/Screens/mainScreen.dart';
import 'package:provider/provider.dart';

import '../Provider/provider.dart';
enum Delivery{
  onDelivery,
  usingMoMo,
}
class CartScreen extends StatefulWidget {
  static const routeName = '/CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<String> promoCode = [
    '' , 'jesus is lord'
  ];
  double calculatedTotal = 0;
  final user = FirebaseAuth.instance.currentUser;
  final _form = GlobalKey<FormState>();
  bool _loading = false;
  int _currentStep = 0 ;
  bool step2  = false ;
   String address = '' ;
   String delivery = '';
   Delivery _delivery = Delivery.usingMoMo;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _shoppingCart = Provider.of<CartProvider>(context);
    final _media = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Padding(
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
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if(_form.currentState!.validate()){
                          _form.currentState!.save();
                          setState(() {
                            _loading = true;
                          });
                          Order.addOrder(
                              order: Order(
                                delivery: delivery,
                                address: address,
                                id: Random(DateTime.now().second)
                                    .nextInt(100000000)
                                    .toString(),
                                total: _shoppingCart.totalAmount(),
                                name: user!.email!,
                                placedOn: DateTime.now(),
                                product: _shoppingCart.cart.values.toList(),
                              )).then((_) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                MainScreen.routeName, (route) => false);
                            _shoppingCart.clearCart();
                            Provider.of<ProductList>(context, listen: false)
                                .clearList();
                          }).catchError((e) {
                            setState(() {
                              _loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('order can not be placed !'),
                            ));
                          });
                        }
                      },
                      child: Text(
                        'Order Now',
                        style: _theme.textTheme.headline6,
                      ),
                    ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(Icons.arrow_back , color: _theme.textTheme.headline6!.color,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 50,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Your Cart', style: _theme.textTheme.headline6),
        backgroundColor: _theme.primaryColor,
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(5),
          children: [
            for (CartItem cart in _shoppingCart.cart.values)
              Padding(
                padding: const EdgeInsets.symmetric( vertical :10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cart.product.name,
                              style: _theme.textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${cart.product.price * cart.quantity}',
                              style: _theme.textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _shoppingCart.addCart(product: cart.product);
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        FittedBox(child: Text(cart.quantity.toInt().toString())),
                        TextButton(
                          onPressed: () {
                            _shoppingCart.removeCartItem(cart.product);
                          },
                          child: const Icon(Icons.remove,
                              color: Colors.orangeAccent),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  height: 60,
                  width: _media * 0.76,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: ' Enter a promo code ',
                      border: InputBorder.none,
                      fillColor: _theme.primaryColor.withOpacity(0.5),
                      filled: true,
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (!promoCode.contains(value)) {
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
                  child: Text(
                    'apply',
                    style: _theme.textTheme.headline6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Text('Delivery Details' , style: _theme.textTheme.headline6,),
            Theme(
              data: ThemeData(
                primaryColor: Color(0xffE8B44A),
                colorScheme: ColorScheme.light(
                  primary: Color(0xffE8B44A),
                ),
              ),
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: (){
                  if (_currentStep < 1 && _form.currentState!.validate()){
                    setState(() {
                      _currentStep ++ ;
                      step2 = true ;
                    });
                  }
                },
                onStepCancel: (){
                  if(_currentStep >=1 ){
                    setState(() {
                      _form.currentState!.save();
                      _currentStep --;
                      step2 = false ;
                    });
                  }
                },
                steps: [
                  Step(
                    state: _currentStep == 0 ? StepState.indexed : StepState.complete ,
                    isActive: true ,
                    title:const Text('Address'),
                    content: TextFormField(
                      onChanged: (value){
                        address = value;
                      },
                      validator: (value){
                        if(value == '' && value!.length <=0 ){
                          return 'we need a valid address';
                        }
                         return null ;
                      },
                      decoration: InputDecoration(
                        hintText: 'address'
                      ),
                    ),
                  ) ,
                  Step(
                    state: _currentStep == 1 ? StepState.indexed : _loading ?  StepState.complete : StepState.indexed,
                    isActive: step2,
                    title: const Text('Payment Method'),
                    content: DropdownButton(
                      value: _delivery,
                      onChanged: (value){
                        setState(() {
                          _delivery = value as Delivery;
                        });
                        if(value == Delivery.usingMoMo) delivery = 'Momo';
                        delivery = 'on delivery';
                      },
                      items: [
                        DropdownMenuItem(child: Text('on delivery') , value: Delivery.onDelivery,onTap: (){
                          FocusScope.of(context).unfocus();
                        },),
                        DropdownMenuItem(child: Text('Using MoMo') , value: Delivery.usingMoMo,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,)

          ],
        ),
      ),
    );
  }
}
