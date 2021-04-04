import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Product {
  final String id ;
  final String name;
  final double price;
  final String url;
  final String  company;
  final String  description;

  Product({ required this.description  , required this.id, required this.name, required this.price, required this.url, required this.company});


}

class ProductList with ChangeNotifier{
  final List<Product> _list =[
    // Product(
    //   id: 'di',
    //   name: 'head',
    //   company: 'Benz',
    //   url: 'https://firebasestorage.googleapis.com/v0/b/garage-app-v1.appspot.com/o/products%2FScreenshot%20from%202021-04-02%2011-12-39.png?alt=media&token=137b3e35-acd0-464e-8d35-904f87522398',
    //  price: 2000,
    // ),
    // Product(
    //   id: 'd1',
    //   name: 'Tires',
    //   company: 'Benz',
    //   url: 'https://firebasestorage.googleapis.com/v0/b/garage-app-v1.appspot.com/o/products%2FScreenshot%20from%202021-04-02%2011-18-03.png?alt=media&token=ae101ef0-cfad-477b-a97b-df91769bbdc6',
    //   price: 200,
    // ),
    // Product(
    //   id: 'd3',
    //   name: 'VolvoDeltax56',
    //   company: 'Volvo',
    //   url: 'https://firebasestorage.googleapis.com/v0/b/garage-app-v1.appspot.com/o/products%2FScreenshot%20from%202021-04-02%2011-21-10.png?alt=media&token=97333515-b03f-42d1-83ec-9362e30d9189',
    //   price: 200000,
    // ),
    // Product(
    //   id: 'd4',
    //   name: 'HeadCxv123',
    //   company: 'Benz',
    //   url: 'https://firebasestorage.googleapis.com/v0/b/garage-app-v1.appspot.com/o/products%2FScreenshot%20from%202021-04-02%2011-12-39.png?alt=media&token=137b3e35-acd0-464e-8d35-904f87522398',
    //   price: 2000,
    // ),
    // Product(
    //   id: 'd5',
    //   name: 'trailer',
    //   company: 'Volvo',
    //   url: 'https://firebasestorage.googleapis.com/v0/b/garage-app-v1.appspot.com/o/products%2FScreenshot%20from%202021-04-02%2011-31-10.png?alt=media&token=07b6c099-b95b-42bf-bd05-4f6a20e7c6b0',
    //   price: 1000,
    // ),
    // Product(
    //   id: 'd5',
    //   name: 'BoxBodytrailer',
    //   company: 'Feng',
    //   url: 'https://firebasestorage.googleapis.com/v0/b/garage-app-v1.appspot.com/o/products%2FScreenshot%20from%202021-04-02%2011-37-08.png?alt=media&token=723c6eb9-0df2-486e-91ce-576fe057a4b6',
    //   price: 1500,
    // ),
  ];
  List<Product> get list => [..._list];

  List<Product> filter(String value){
    return _list.where((pr) => pr.name.contains(value)).toList();
  }

  Future <void>fetchAndSetProduct()async{
    final QuerySnapshot _product = await FirebaseFirestore.instance.collection('Products').get();
    _product.docs.forEach((doc) {
      _list.insert(0, Product(
        description: doc['description'],
        price: double.parse(doc['price'].toString()),
        url: doc['url'],
        company: doc['company'],
        name: doc['name'],
        id: doc['id'],
      ));
    });
    notifyListeners();
    print('this is where my list lies :   ${_list.first.price}');
  }
}