import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
class Auth {
 static  Future<void> createAccount(
      {required String name,
        required String phoneNumber ,
        required String email,
        required String password,
      required File file}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password ,);
        final UploadTask stored = FirebaseStorage.instance.ref('profile/$name.png').putFile(file);
        stored.snapshotEvents.listen((snapshot){
          print(' this is what is happening now ${snapshot.bytesTransferred / snapshot.totalBytes * 100}');
        });
        print('total amount of bytes needed -------->${stored.snapshot.totalBytes}');
        print('amount being uploaded ---------> ${stored.snapshot.bytesTransferred}');
        print('checking the state of the upload ---------> ${stored.snapshot.state}');

        final imageUrl = await stored.snapshot. ref.getDownloadURL();
      userCredential.user!.updateProfile(
        displayName: name,
        photoURL: imageUrl,
      );
      userCredential.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      print(e);
    }
  }

  static Future<void> signIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
     throw e.message!;
    } catch (e) {
      print(e);
    }
  }
  static Future<void> logOut()async{
    try{
      await FirebaseAuth.instance.signOut();
    }on FirebaseAuthException catch(e){
      print(e);
    }catch(e){
      print(e);
    }
  }
 static Future<void> resetPassword({required String email}) async{
   try{
     await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
   }on FirebaseAuthException catch(e){
     throw e.message!;
   }catch(e){
     print(e.toString());
   }
}
}