import 'package:cloud_firestore/cloud_firestore.dart';
class Chat {
  DateTime date = DateTime.now(); String content;
  String sender ;

  Chat({ this.content  = '', this.sender = ''});


   Future<void> sendMessage( {required Chat chat , required String id })async{
  try{
    await FirebaseFirestore.instance.collection('Messages').doc(id).collection('Message').add({
      'id' : date.toIso8601String(),
      'sender': chat.sender,
      'content':chat.content,
    });
  }catch(e){
    throw e ;
  }
  }

}


