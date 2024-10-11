import 'package:flutter/material.dart';
import 'friend_page.dart';
import 'host_page.dart';
import 'profil_page.dart';
import 'join_page.dart';
import 'game_page.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    // GameScreen(),
    HostScreen(),
    JoinScreen(),
    FriendScreen(),
    ProfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Héberger',
            backgroundColor: Color(0xFF7FDEFF),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Rejoindre',
            backgroundColor: Color(0xFFDABFFF),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Mes amis',
            backgroundColor: Color(0xFFB3EFB2),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon profil',
            backgroundColor: Color(0xFFFFBFA0),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0B132B),
        onTap: _onItemTapped,
      ),
    );
  }
}

