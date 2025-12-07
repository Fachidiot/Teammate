import 'package:flutter/material.dart';
import 'ProfileWidget.dart';
import 'AIScorePage.dart'; // 새로 만든 AI 페이지 연결

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
    // 탭 순서 정의: 0번(AI진단), 1번(프로필)
    _widgetOptions = <Widget>[
      const AIScorePage(),
      ProfileWidget(user: _user, onProfileUpdated: _updateUser),
    ];
  }

  void _updateUser(Map<String, dynamic> newUser) {
    setState(() {
      _user = newUser;
      _widgetOptions[1] = ProfileWidget(user: _user, onProfileUpdated: _updateUser);
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
      // 모던하고 심플한 하단 탭바
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF3B82F6), // 메인 블루 컬러
          unselectedItemColor: Colors.grey[400],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'AI 진단',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: '내 프로필',
            ),
          ],
        ),
      ),
    );
  }
}