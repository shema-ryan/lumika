import 'package:flutter/material.dart';
import '../Backend/backend.dart';
class ResetPassword extends StatefulWidget {
  static const String routeName = 'ResetPassWord';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _form3 = GlobalKey<FormState>();
  String ? email ;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title:  Text('Reset Password' , style: _theme.textTheme.headline6!.copyWith(
          color: _theme.primaryColor,
        ),),
      ),
      body: Form(
        key: _form3,
        child: SingleChildScrollView(
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset('assets/reset.png'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal :40.0 , vertical: 20.0),
                child: Text('Worry out provide your email , we will send a reset instruction to your email' , style:_theme.textTheme.bodyText2 ,),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  onSaved: (value){
                    email = value ;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                   border:const OutlineInputBorder(
                     borderSide: BorderSide(
                       color: Colors.black54,
                       width: 5,
                       style: BorderStyle.solid
                     )
                   ),
                    fillColor:_theme.primaryColor.withOpacity(0.5) ,
                    filled: true,
                    hintText: 'email',
                  ),
                  validator: (value){
                    if(!value!.contains('@')){
                      return 'dear provide a valid email';
                    }
                    else{
                      return null ;
                    }
                  },
                ),
              ),
              Container(
                margin:const EdgeInsets.all(10),
                width: 150,
                child:ElevatedButton(
                  onPressed: (){
                    _form3.currentState!.save();
                    if(_form3.currentState!.validate()){
                      Auth.resetPassword(email: email!).then((_){
                        Navigator.of(context).pop();
                      }).catchError((e){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      });
                    }
                  },
                  child: const Text('Reset' , style: TextStyle(color: Colors.black54),),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
