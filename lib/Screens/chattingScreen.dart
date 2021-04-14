import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChattingScreen extends StatefulWidget {
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  var _determined  = FirebaseAuth.instance.currentUser;

  //determining chat id function
  String chatIdGroup( String userName){
    if(userName.hashCode <= 'kamanzishema@gmail.com'.hashCode ){
      return '$userName-kamanzishema@gmail.com';
    }
    else{
      return 'kamanzishema@gmail.com-$userName';
    }
  }
  // unique id to listenning to in firestore
  String? chatId = '';

  @override
  void initState() {
    super.initState();
    chatId = chatIdGroup(_determined!.email!);
  }
  
  @override
  Widget build(BuildContext context) {

   return Scaffold(
     body: StreamBuilder(
       stream: FirebaseFirestore.instance.collection('Messages').doc(chatId).collection('Message').orderBy('id' , descending:true).limitToLast(10).snapshots(),
         builder: (context , AsyncSnapshot<QuerySnapshot >snapshot ){
         if(snapshot.hasError){
           return const Text('there is an error please ') ;
         }
         else if(snapshot.connectionState == ConnectionState.waiting){
           return const Center(child: CircularProgressIndicator(),);
         }
         else {
           return ChatWidget(chatId!, snapshot.data!.docs , '');
         }
         }),
   ) ;

  }
}
