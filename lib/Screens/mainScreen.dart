import 'package:flutter/material.dart';
import '../Screens/screens.dart';
import 'package:provider/provider.dart';
import '../Provider/provider.dart';
class MainScreen extends StatefulWidget {
  const MainScreen();
  static const String routeName = '/MainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  initState(){
    super.initState();
    Future.delayed(Duration.zero, () async{
      Provider.of<ProductList>(context , listen: false).fetchAndSetProduct();
    });
  }
  int _selectedIndex = 0 ;
  List _screen = List.unmodifiable([
    ProductScreen(),
    OrderScreen(),
    ChattingScreen(),
    ProfileScreen(),
  ]);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Scaffold(
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _theme.primaryColor,
        currentIndex: _selectedIndex,
        selectedItemColor: _theme.primaryColor,
        unselectedItemColor: _theme.accentColor ,
        onTap: (selectedIndex){
        setState(() {
          _selectedIndex = selectedIndex;
        });
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home) ,label: 'home' ),
          BottomNavigationBarItem(icon: const Icon(Icons.shopping_bag_rounded) , label: 'orders'),
          BottomNavigationBarItem(icon: Icon(Icons.message) , label: 'messages' , activeIcon: Icon(Icons.chat_bubble_outline)),
          BottomNavigationBarItem(icon: const Icon(Icons.person_rounded),label: 'profile'),
        ],
      ),
    );
  }
}
