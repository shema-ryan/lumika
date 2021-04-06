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
    ProductScreen(),
  ]);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Scaffold(
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _theme.primaryColor,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black54,
        unselectedItemColor: _theme.accentColor ,
        onTap: (selectedIndex){
        setState(() {
          _selectedIndex = selectedIndex;
        });
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home) ,label: 'home' ),
          BottomNavigationBarItem(icon: const Icon(Icons.shopping_bag_rounded) , label: 'orders'),
          BottomNavigationBarItem(icon: const Icon(Icons.person_rounded),label: 'profile'),
        ],
      ),
    );
  }
}
