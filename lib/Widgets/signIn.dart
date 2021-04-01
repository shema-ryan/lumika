import 'package:flutter/material.dart';
import '../Screens/screens.dart';
import '../Backend/backend.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _form = GlobalKey<FormState>();
  bool _hide = true;
  bool _loading = false ;
  String? email ;
  String? password ;
  void handleError(String message){
    final _theme = Theme.of(context);
    final _scaffold = ScaffoldMessenger.of(context);
    _scaffold.showSnackBar(SnackBar(
      shape:const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(5.0),
          topRight: const Radius.circular(5.0)
        ),
      ),
      backgroundColor: _theme.errorColor,
      content: Text(message),
    ));

  }
   // funcition for sign

  void signIn(String email , String password){
    if(_form.currentState!.validate()){
      setState(() {
        _loading = true ;
      });
      Auth.signIn(email: email, password: password).then((value) => _loading = false).catchError((e){
        setState(() {
          _loading = false;
        });
        handleError(e);
      });
    }
  }

  // SignInwith google

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _media = MediaQuery.of(context).size.width;
    return Form(
      key: _form,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          SizedBox(
            height: _media * 0.05,
          ),
          Row(
            children: [
              const Icon(
                Icons.person,
                color: Colors.black54,
              ),
              Expanded(
                child: TextFormField(
                  onSaved: (value){
                    email = value ;
                  },
                  cursorColor: Colors.black12,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (!value!.contains('@')) {
                      return 'provide a valid mail';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: _media * 0.025,
          ),
          Row(
            children: [
              const Icon(
                Icons.lock,
                color: Colors.black54,
              ),
              Expanded(
                child: TextFormField(
                  onSaved: (value){
                    password = value ;
                  },
                  maxLength: 10,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'too short';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black12,
                  obscureText: _hide,
                  obscuringCharacter: '*',
                  decoration: const InputDecoration(hintText: 'password'),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      setState(() {
                        _hide = !_hide;
                      });
                    },
                    child: const Icon(Icons.remove_red_eye_outlined)),
              ),
            ],
          ),
          SizedBox(
            height: _media * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _loading ? Center(child: const CircularProgressIndicator(),):Container(
                width: _media * 0.39,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: _theme.primaryColor,
                      textStyle: _theme.textTheme.headline6),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _form.currentState!.save();
                    signIn(email!, password!);
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
              if(!_loading)TextButton(onPressed: (){
                Navigator.of(context).pushNamed(ResetPassword.routeName);
              }, child: const Text('forgot password ?' , style: TextStyle(color: Colors.black54),))
            ],
          ),
          if(!_loading)SizedBox(
            height: _media * 0.045,
          ),
          if(!_loading)Row(
            children: [
              const Expanded(child: Divider()),
              const Text('  OR Continue with  '),
              const Expanded(child: const Divider()),
            ],
          ),
          if(!_loading)SizedBox(
            height: _media * 0.05,
          ),
          if(!_loading)Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: _media * 0.38,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text('Google'),
                  style: ElevatedButton.styleFrom(
                    textStyle: _theme.textTheme.headline6,
                    primary: const Color(0xffEA4335),
                  ),
                ),
              ),
              Container(
                width: _media * 0.38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: _theme.textTheme.headline6,
                    primary: const Color(0xff3b5998),
                  ),
                  onPressed: () {},
                  child: const Text('facebook'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
