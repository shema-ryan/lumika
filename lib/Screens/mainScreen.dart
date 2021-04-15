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
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      Provider.of<ProductList>(context, listen: false).fetchAndSetProduct();
    });
  }

  int _selectedIndex = 0;

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
        showSelectedLabels: false,
        selectedItemColor: _theme.textTheme.headline6!.color,
        unselectedItemColor:Colors.black54,
        type: BottomNavigationBarType.fixed,
        onTap: (selectedIndex) {
          setState(() {
            _selectedIndex = selectedIndex;
          });
        },
        items: [
          const BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: 'home'),
          const BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_bag_rounded), label: 'orders'),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.message),
            label: 'messages',
          ),
          const BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded), label: 'profile'),
        ],
      ),
    );
  }
}
