import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {



 static  Future<void> createAccount(
      {required String name,
        required String phoneNumber ,
        required String email,
        required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password ,);
      userCredential.user!.updateProfile(
        displayName: name,
        photoURL: phoneNumber,
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

 static Future<void>signInWithGoogle()async{
   //trigger
try{
  final GoogleSignInAccount? trigger = await GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.co-m/auth/contacts.readonly',
    ],
  ).signIn();
  //obtain auth credential
  final GoogleSignInAuthentication? googleAuth = await trigger!.authentication;
  // create credential
  final OAuthCredential? credential = GoogleAuthProvider.credential(
    accessToken: googleAuth!.accessToken,
    idToken: googleAuth.idToken,
  );
  // signIn with credential
  await FirebaseAuth.instance.signInWithCredential(credential!);
} on FirebaseAuthException catch(e){
  throw e.message!;
}catch(e){
  print('shema Amandin ${e.toString()}');
  throw e.toString();
}
}

}