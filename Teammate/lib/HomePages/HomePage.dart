import 'package:flutter/material.dart';
import 'ProfileWidget.dart';
import 'TeamsWidget.dart';
import 'FindWidget.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Map<String, dynamic> _user;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _widgetOptions = <Widget>[
      const FindWidget(),
      const TeamsWidget(),
      ProfileWidget(user: _user, onProfileUpdated: _updateUser),
    ];
  }

  void _updateUser(Map<String, dynamic> newUser) {
    setState(() {
      _user = newUser;
      _widgetOptions[2] = ProfileWidget(user: _user, onProfileUpdated: _updateUser);
    });
  }

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
