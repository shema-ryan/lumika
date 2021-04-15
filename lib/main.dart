import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:garage/Provider/cartProvider.dart';
import 'package:provider/provider.dart';
import './Provider/provider.dart';
import 'package:garage/Screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';





void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(
          create: (_)=> CartProvider(),
        ),
        ChangeNotifierProvider<AppTheme>(
          create:(_)=> AppTheme() ,
        ),
        ChangeNotifierProvider<ProductList>(
          create:(_)=> ProductList(),
        ),
      ],
      child:HomePage(),
    );
  }
}
class HomePage extends StatelessWidget {

  static final String routeName = '/';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'garage',
      theme:Provider.of<AppTheme>(context).appTheme(),
      home: StreamBuilder<dynamic>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError){
            return Scaffold(body: Center(child:const  Text('we had got an error'),),);
          }
          else if (snapshot.connectionState == ConnectionState.done){
            return Scaffold(
              body: const Center(child:const  Center(child: const CircularProgressIndicator(),),),
            );
          }
          else if(snapshot.data != null ){
            if(snapshot.data.emailVerified){
              return MainScreen();
            }
            return  ConfirmScreen();
          }
          else{
            return const AuthenticationScreen();
          }
        }
      ),
      routes: {
        AuthenticationScreen.routeName:(BuildContext context )=>AuthenticationScreen(),
        ResetPassword.routeName:(BuildContext context )=>ResetPassword(),
        MainScreen.routeName : (BuildContext context)=>MainScreen(),
        ConfirmScreen.routeName :(BuildContext context)=> ConfirmScreen(),
        ProductScreen.routeName :(BuildContext context )=>ProductScreen(),
        DetailsScreen.routeName : (BuildContext context )=>DetailsScreen(),
        CartScreen.routeName:(BuildContext context)=> CartScreen(),
        OrderScreen.routeName:(BuildContext context)=> OrderScreen(),
      },
      onUnknownRoute: (RouteSettings routeGen){
        if(routeGen.name != null){
          return MaterialPageRoute(builder: (context)=> Scaffold(
            appBar: AppBar(title:  Text('Sorry Beloved' , style: Theme.of(context).textTheme.headline6,), centerTitle: true, elevation: 0.0, iconTheme:Theme.of(context).iconTheme,),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/404.png'),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('No page found !' , style: Theme.of(context).textTheme.headline6!),
                )
              ],
            ),
          ));
        }
      },

    ) ;
  }
}







