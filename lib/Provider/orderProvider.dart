import '../Provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Order{
  final String id ;
  final String address;
  final String delivery;
  final String name ;
  final DateTime placedOn ;
  final List<CartItem> product ;
  final double total ;
  String deliveryStatus = 'ordered';
  Order({  this.deliveryStatus = 'ordered' , required this.delivery , required this.address , required this.id , required this.total ,required this.name, required this.placedOn, required this.product});

 static  Future<void> addOrder({required Order order })async{
    try{
      await FirebaseFirestore.instance.collection('Order').add({
        'status':order.deliveryStatus,
        'delivery':order.delivery,
        'address':order.address,
        'id' : order.id,
        'orderBy' : order.name ,
        'placedOn' : order.placedOn.toIso8601String(),
        'amount': order.total,
        'products' : order.product.map((pr) => {
          'id' : pr.id ,
          'quantity':pr.quantity,
          'product': {
            'id' : pr.product.id ,
            'price': pr.product.price,
            'name':pr.product.name,
            'url':pr.product.url,
            'description':pr.product.description,
            'company':pr.product.company
          }
        }).toList(),
      });
    }
    catch(e){
      throw e ;
    }
  }
  
 static Future<List<Order>> fetchAndSetOrder(String name)async{
   QuerySnapshot doc = await FirebaseFirestore.instance.collection('Order').orderBy('placedOn' , descending: true).where('orderBy' , isEqualTo: name).get();
   List<Order> _order = [] ;
   doc.docs.forEach((element) {
     _order.add(Order(
       deliveryStatus: element['status'],
       delivery: element['delivery'],
       address: element['address'],
       id: element['id'] ,
       name: element['orderBy'],
       total: element['amount'],
       placedOn: DateTime.parse(element['placedOn']),
       product: (element['products'] as List<dynamic>).map((e) =>CartItem(
         id: e['id'],
         quantity: e['quantity'],
         product: Product(
           id: e['product']['id'],
           price: e['product']['price'],
           name: e['product']['name'],
           url: e['product']['url'],
           company: e['product']['company'],
           description: e['product']['description'],
         ),
       )).toList()
     ));
   });
   return _order;

  }
}

