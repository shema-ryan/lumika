import 'package:flutter/material.dart';
import '../Backend/backend.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _form2 = GlobalKey<FormState>();
  bool _loading = false ;
  bool _checked = false ;
  bool _hide = true ;
  String? userName ;
  String? phoneNumber ;
  String? email ;
  String? passWord;

  // function to handle error message

  void handleError(String message){
    final _theme = Theme.of(context);
    final _scaffold = ScaffoldMessenger.of(context);
    _scaffold.showSnackBar(SnackBar(
      backgroundColor: _theme.errorColor,
      content: Text(message),
    ));

  }
  // FUNCTION FOR CREATING USER ACCOUNT

  void createUser({required String email , required String password ,  required String userName , required String phoneNumber}){
    _form2.currentState!.validate();
    if(!_checked){
     handleError('Read and Accept Terms and Conditions');
    }
    else if (_form2.currentState!.validate() && _checked){
      print('am here');
      setState(() {
        _loading = true ;
      });
      Auth.createAccount(name: userName, email: email, password: password ,phoneNumber: phoneNumber).then((value){
        _loading = false ;
      }).catchError((e){
        setState(() {
          _loading = false ;
        });
        handleError(e);
      });
    }
  }
  // CREATING USER ACCOUNT
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _media = MediaQuery.of(context).size.width;
    return Form(
      key: _form2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          SizedBox(height: _media * 0.05,),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person , color: Colors.black54,),
                    Expanded(child: TextFormField(
                      onSaved: (value){
                        userName = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if(value!.length < 6){
                          return 'too short';
                        }
                        return null ;
                      },
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black12,
                      decoration: InputDecoration(
                          hintText: 'username'
                      ),
                    )),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.phone, color: Colors.black54,),
                    Expanded(child: TextFormField(
                      onSaved: (value){
                        phoneNumber = value ;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if(value!.length < 6){
                          return 'too short';
                        }
                        return null ;
                      },
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black12,
                      decoration: InputDecoration(
                          hintText: 'phoneNumber'
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: _media * 0.05,
          ),
          Row(
            children: [
              Icon(Icons.mail_outline, color: Colors.black54,),
              Expanded(
                child: TextFormField(
                  onSaved: (value){
                    email = value ;
                  },
                  cursorColor: Colors.black12,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: 'email'
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if(!value!.contains('@')){
                      return 'provide a valid mail';
                    }
                    return null ;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height:  _media * 0.025,),
          Row(
            children: [
              Icon(Icons.lock , color: Colors.black54,),
              Expanded(child: TextFormField(
                onSaved: (value){
                  passWord = value ;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if(value!.length < 6){
                    return 'too short';
                  }
                  return null ;
                },
                textInputAction: TextInputAction.next,
                cursorColor: Colors.black12,
                obscureText: _hide,
                obscuringCharacter: '*',
                maxLength: 10,
                decoration: InputDecoration(
                    hintText: 'password'
                ),
              )),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      setState(() {
                        _hide = !_hide;
                      });
                    },
                    child: const Icon(Icons.remove_red_eye_outlined)),
              ),
            ],
          ),
          SizedBox(
            height: _media * 0.05,
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
           activeColor:_theme.primaryColor,
            title: GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    actions: [
                      Container(
                        width:100 ,
                          child: TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child: Text('Ok')))
                    ],
                    title: const Text('Garage' , textAlign: TextAlign.center,),
                    content: Text('Garage does not collect any User data ....\n However you might required to purchase a subscription token to access addittion features'),
                  );
                }).then((value) => print(value));
              },
                child: Text('Accept Terms and Conditions')),
              value: _checked, onChanged: (value){
            setState(() {
              _checked = value! ;
            });
          }),
         _loading? Center(child: const CircularProgressIndicator(),): Container(
            width:  _media * 0.39,
            child: ElevatedButton(
              style:ElevatedButton.styleFrom(
                  elevation: 0.0 ,
                  primary: _theme.primaryColor,
                  textStyle: _theme.textTheme.headline6
              ),
              onPressed: (){
                _form2.currentState!.save();
               createUser(email: email!, password: passWord!, userName: userName!, phoneNumber: phoneNumber! ,);
              },
              child: Text('SignUp'),
            ),
          ),
          SizedBox(height:  _media * 0.025,),
        ],
      ),
    );
  }
}
