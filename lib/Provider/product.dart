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
  ];
  List<Product> get list => [..._list];

  List<Product> filter(String value){
    return _list.where((pr) => pr.name.contains(value)).toList();
  }

  Future <void>fetchAndSetProduct()async{
   try{
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
   }catch(e){
     print('loading product error : $e');
   }
  }

  void clearList(){
    _list.clear();
  }
}