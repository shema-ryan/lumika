import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage/Backend/authBackEnd.dart';
import '../Screens/settingScreen.dart';
import 'package:url_launcher/url_launcher.dart';

// 0779190049 saxon
// Aspire1
// 0787299206
class ProfileScreen extends StatelessWidget {
  final email = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _media = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('Users')
              .where('email', isEqualTo: email)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
            if (snapShot.hasError) {
              return Center(
                child: const Text('An Error pull to refresh'),
              );
            }
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              final data = snapShot.data!.docs[0];
              return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  actions: [
                    PopupMenuButton(
                        onSelected: (value) {
                          if (value == 1) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                Navigator.defaultRouteName,
                                (route) => false);
                            Auth.logOut();
                          }
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text(
                                  'log out',
                                  style: _theme.textTheme.headline6,
                                ),
                                value: 1,
                              )
                            ])
                  ],
                ),
                body: Column(
                  children: [
                    Container(
                      height: _media * 0.76,
                      width: double.infinity,
                      child: Image.network(
                        data['url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    listTileBuilder(Icons.person, data['name'], context),
                    listTileBuilder(Icons.phone, data['phoneNumber'], context),
                    listTileBuilder(Icons.mail_outline, data['email'], context),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SettingScreen()));
                        },
                        child: listTileBuilder(
                            Icons.settings, 'Settings', context)),
                    GestureDetector(
                        onTap: () {
                          Scaffold.of(context).showBottomSheet((context) =>
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          urlWidget(
                                              'tel:+256781036150',
                                              Icons.phone_android,
                                              'call',
                                              context),
                                          urlWidget('sms:+256781036150',
                                              Icons.message, 'sms', context),
                                          urlWidget(
                                              'mailto:kamanzishema@gmail.com?subject=TalktoLumikaDevTeam&body=amen',
                                              Icons.mail,
                                              'Email',
                                              context),
                                        ],
                                      ),
                                    ],
                                  ),
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: _theme.primaryColor.withOpacity(0.7),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10)),
                                  ),
                                ),
                              ));
                        },
                        child: listTileBuilder(
                            Icons.contact_support, 'contact lumika', context)),
                  ],
                ),
              );
            }
          }),
    );
  }
}

ListTile listTileBuilder(IconData icon, String name, BuildContext context) {
  return ListTile(
    leading: Icon(
      icon,
      color: Color(0xffE8B44A),
    ),
    title: Text(
      name,
      style: Theme.of(context).textTheme.headline6,
    ),
    trailing: name == 'Settings' ? Icon(Icons.arrow_forward_ios) : null,
  );
}

Widget urlWidget(String url, IconData icon, String desc, BuildContext context) {
  return GestureDetector(
    onTap: () {
      launch(url).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(e.toString()),
        ));
      });
    },
    child: Column(
      children: [
        Icon(icon),
        Text(desc),
      ],
    ),
  );
}

Future<void> launchUrl(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'can\'t launch $url';
}
