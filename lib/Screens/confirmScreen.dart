import 'package:flutter/material.dart';
import '../Backend/backend.dart';
class ConfirmScreen extends StatelessWidget {
  static const String routeName = '/confirmScreen';
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title:  Text('Confirm your Email' , style: _theme.textTheme.headline6!.copyWith(
          color: _theme.primaryColor,
        ),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text('a mail has been sent to your email please verify for authentic purpose ' , style:_theme.textTheme.bodyText2 ,),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child:Image.asset('assets/confirm1.png'),),

                SizedBox(
                  height: 50,
                ),
                Container(
                  width: double.infinity,
                    child: ElevatedButton(onPressed: (){
                      Auth.logOut();
                    }, child: const Text('Alright'),))
              ],
            ),
          ),)
        ],
      ),
    );
  }
}
