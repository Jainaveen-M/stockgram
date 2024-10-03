import 'package:flutter/material.dart';
import 'package:stockgram/presentation/screens/algo_trading.dart';
import 'package:stockgram/presentation/screens/home.dart';
import 'package:stockgram/presentation/screens/profile.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    Home(),
    AlgoTrading(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add_chart_sharp),
              label: 'Market',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.whatshot_outlined),
              label: 'Bot Trading',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped, //New
        ));
  }
}
