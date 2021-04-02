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
        final stored = await FirebaseStorage.instance.ref('profile/$name.png').putFile(file);
        final imageUrl = await stored. ref.getDownloadURL();
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