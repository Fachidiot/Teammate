import 'package:flutter/material.dart';
import 'ProfileWidget.dart';
import 'TeamsWidget.dart';
import 'FindWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    const FindWidget(),
    const TeamsWidget(),
    const ProfileWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '팀 찾기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '내 팀메이트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 프로필',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
