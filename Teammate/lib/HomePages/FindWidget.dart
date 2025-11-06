import 'package:flutter/material.dart';

class FindWidget extends StatefulWidget {
  const FindWidget({super.key});

  @override
  State<FindWidget> createState() => _FindWidgetState();
}

class _FindWidgetState extends State<FindWidget> {
  // 예시 데이터를 위한 더미 리스트
  final List<Map<String, String>> _teamList = List.generate(
    10,
    (index) => {
      'label': 'Message Label ${index + 1}',
      'description': 'Message description',
      'date': 'Date',
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
        title: const Text('팀 찾기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 검색 기능 구현
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
              // TODO: 리스트 아이템 탭 기능 구현
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
