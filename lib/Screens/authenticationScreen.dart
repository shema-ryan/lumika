import 'package:flutter/material.dart';
import '../Widgets/widget.dart';
import 'package:permission_handler/permission_handler.dart';
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen();

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> with SingleTickerProviderStateMixin{
   TabController? _tabController ;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.delayed(Duration.zero , ()async{
      await Permission.camera.request();
      await Permission.location.request();
    });
  }
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _media = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          child: SafeArea(
            child: ListView(
              children: [
                SizedBox(
                  height:  _media * 0.12,
                ),
               Center(
                 child: RichText(
                 text: TextSpan(
                   style: _theme.textTheme.headline6,
                   children: [
                      TextSpan(
                       text: 'Welcome to ',
                       style: _theme.textTheme.headline6!.copyWith(
                         color: Colors.white,
                       )
                     ),
                     TextSpan(
                       text: 'Lumika',
                       style: _theme.textTheme.headline6!.copyWith(
                         color: Color(0xffE8B44A),
                         fontWeight: FontWeight.bold,
                       )
                     )
                   ]
                 ),
                 ),
               ),
               const  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:const Text('a one stop center for your automobile spare parts and  repair......', style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                  ),),
                ),
                SizedBox(
                  height:  _media * 0.05,
                ),
                Card(
                  color: Colors.white.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TabBar(
                             indicatorColor: _theme.primaryColor,
                              controller: _tabController,
                              tabs: [
                                const Tab(
                                  child: const Text('Sign In'),
                                ),
                                const Tab(
                                  text: 'Create Account',
                                ),
                              ],
                            ),
                        Container(
                          height:  _media ,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              SignIn(),
                              SignUp(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

            ),
          ),

       decoration:const BoxDecoration(
         image: const DecorationImage(
           fit: BoxFit.cover,
           image: const AssetImage('assets/s_77H.jpg'),
         ),
       ),
      ),
    );
  }
}
