import 'dart:io';
import 'package:flutter/material.dart';
import '../Backend/backend.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _form2 = GlobalKey<FormState>();
  bool _loading = false ;
  bool _checked = false ;
  bool _hide = true ;
  bool _changeImage = false ;
  final ImagePicker _picker = ImagePicker();

  File? _image;
  String? userName ;
  String? phoneNumber ;
  String? email ;
  String? passWord;
  Future<void> pickImage(ImageSource imageSource )async{
     final picked = await _picker.getImage(source: imageSource  , imageQuality: 50 , maxHeight: 100 , maxWidth: 100);
     if(picked != null){
       setState(() {
         _image = File(picked.path);
         _changeImage = true;
       });
     }
  }
  // function to handle error message

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
  // FUNCTION FOR CREATING USER ACCOUNT

  void createUser({required String email , required String password ,  required String userName , required String phoneNumber}){
    _form2.currentState!.validate();
    if(!_checked){
     handleError('Read and Accept Terms and Conditions');
    }
    if(_image == null){
      handleError('please provide a profile photo');
    }
    else if (_form2.currentState!.validate() && _checked){
      setState(() {
        _loading = true ;
      });
      Auth.createAccount(name: userName, email: email, password: password ,phoneNumber: phoneNumber,file : _image!).then((value){
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: _media * 0.05,),
            Stack(
             clipBehavior: Clip.none,
              children: [
               !_changeImage ? const CircleAvatar(
                  radius: 60,
                  backgroundImage: const AssetImage('assets/profice.png'),
                ) :CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(_image!),
                ),
                Positioned(
                  right:-10.0,
                  bottom:-10.0,
                  child: IconButton(
                    onPressed: ()async{
                      var status = await Permission.camera.status;
                      if(status.isGranted){
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent ,context: context, builder: (context ){
                          return Container(
                            height: 200,
                           width: double.infinity,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius:const BorderRadius.only(
                               topRight:const Radius.circular(10.0),
                               topLeft: const Radius.circular(10.0)
                             ),
                           ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                               Container(
                                 height: 5,
                                 width: 100,
                                 decoration: BoxDecoration(
                                   color: _theme.primaryColor,
                                   borderRadius: BorderRadius.circular(5)
                                 ),
                               ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    ListTile(
                                      onTap: (){
                                        pickImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                      leading: Icon(Icons.photo_camera , color: _theme.primaryColor,),
                                      title: Text('picture' , style: _theme.textTheme.headline6,),
                                    ),
                                      ListTile(
                                        onTap: (){
                                          pickImage(ImageSource.gallery);
                                          Navigator.of(context).pop();
                                        },
                                        leading: Icon(Icons.photo , color: _theme.primaryColor,),
                                        title: Text('gallery',style: _theme.textTheme.headline6,),
                                      ),
                              ],
                            ),
                          );
                        });
                      }else{
                       Permission.camera.request();
                      }
                    },
                    icon:const Icon(Icons.camera_alt_rounded, size: 40),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                   const    Icon(Icons.person , color: Colors.black54,),
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
                        decoration:const  InputDecoration(
                            hintText: 'username'
                        ),
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                     const Icon(Icons.phone, color: Colors.black54,),
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
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black12,
                        decoration:const  InputDecoration(
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
               const Icon(Icons.mail_outline, color: Colors.black54,),
                Expanded(
                  child: TextFormField(
                    onSaved: (value){
                      email = value ;
                    },
                    cursorColor: Colors.black12,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
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
                  decoration:const InputDecoration(
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
                            }, child: const Text('Ok')))
                      ],
                      title: const Text('Garage' , textAlign: TextAlign.center,),
                      content:const Text('Garage does not collect any User data ....\n However you might required to purchase a subscription token to access addittion features'),
                    );
                  }).then((value) => print(value));
                },
                  child:const Text('Accept Terms and Conditions')),
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
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
