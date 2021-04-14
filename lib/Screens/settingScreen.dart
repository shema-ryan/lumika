import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garage/Provider/appTheme.dart';

import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: _theme.textTheme.headline6!.color,
        ),
        backgroundColor: _theme.primaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: _theme.textTheme.headline6,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  SwitchListTile.adaptive(
                activeColor: _theme.primaryColor,
                value: !Provider.of<AppTheme>(context).light,
                onChanged: (value) {
                  Provider.of<AppTheme>(context, listen: false)
                      .changeTheme();
                },
                title: Text('darkTheme' , style: _theme.textTheme.headline6,),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              child: const Text('View License'),
              onPressed: (){
                showDialog(context: context , builder: (context)=>AboutDialog(
                  children: [
                    const Text('we only lumika we it comes to tracter ')
                  ],
                  applicationName: 'Lumika',
                  applicationIcon: Image.asset('assets/ic_launcher.png' , height: 40, width: 40,),
                  applicationVersion: '1.0.0+1',
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}


