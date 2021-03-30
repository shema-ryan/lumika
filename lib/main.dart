import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
        ChangeNotifierProvider<AppTheme>(
          create:(_)=> AppTheme() ,
        ),
      ],
      child:HomePage(),
    );
  }
}
class HomePage extends StatelessWidget {
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
            print('we reached the end ');
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
        ResetPassword.routeName:(BuildContext context )=>ResetPassword(),
        MainScreen.routeName : (BuildContext context)=>MainScreen(),
        ConfirmScreen.routeName :(BuildContext context)=> ConfirmScreen(),
      },
    ) ;
  }
}







