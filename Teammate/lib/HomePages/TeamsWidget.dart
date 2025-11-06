import 'package:flutter/material.dart';
import 'package:teammate/HomePages/TeamDetailPage.dart'; // 상세 페이지 import

class TeamsWidget extends StatefulWidget {
  const TeamsWidget({super.key});

  @override
  State<TeamsWidget> createState() => _TeamsWidgetState();
}

class _TeamsWidgetState extends State<TeamsWidget> {
  // 예시 데이터를 위한 더미 리스트
  final List<Map<String, String>> _teamList = List.generate(
    10,
    (index) => {
      'label': 'Message Label ${index + 1}',
      'description': 'Message description for team ${index + 1}',
      'date': '2023-10-27',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: 햄버거 메뉴 기능 구현
          },
        ),
        title: const Text('팀 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: 필터 기능 구현
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: _teamList.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _teamList[index];
          return ListTile(
            leading: const CircleAvatar(
              radius: 25,
              child: Icon(Icons.image_outlined),
            ),
            title: Text(
              item['label']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(item['description']!),
            trailing: Text(item['date']!),
            onTap: () {
              // 리스트 아이템 탭 시 상세 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamDetailPage(teamData: item),
                ),
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
