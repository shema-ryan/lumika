import 'package:flutter/material.dart';
import 'package:garage/Widgets/OrderWidget.dart';
import '../Provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
class OrderScreen extends StatelessWidget {
  static const String routeName = 'OrderScreen';
  final name  = FirebaseAuth.instance.currentUser!.displayName;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Scaffold(
      appBar:AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('Your Order', style: _theme.textTheme.headline6!.copyWith(
          color: const Color(0xffE8B44A),
        )),
      ),
      body: FutureBuilder(
        future: Order.fetchAndSetOrder(name!),
        builder: ((BuildContext context,AsyncSnapshot<List<Order>> snapshot ){
          if(snapshot.hasError){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/404.png'),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('An error occurred check your connectivity' , style: Theme.of(context).textTheme.bodyText2!),
                )
              ],
            );

          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: const CircularProgressIndicator(),);
          }
          return OrderWidget(snapshot.data!);
        }),
      ),
    );
  }
}
