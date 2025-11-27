import 'package:flutter/material.dart';
import 'package:teammate/HomePages/FindDetailPage.dart';

class FindWidget extends StatelessWidget {
  const FindWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // DUMMY DATA
    final List<Map<String, String>> users = List.generate(20, (index) => {
      'name': '사용자 ${index + 1}',
      'position': ['개발자', '디자이너', '기획자'][index % 3],
      'introduction': '안녕하세요! 함께 성장할 팀원을 찾고 있습니다. 열정 넘치는 분들을 기다립니다. 잘 부탁드립니다!',
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('팀원 찾기'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = (constraints.maxWidth / 250).floor();
          if (crossAxisCount < 1) crossAxisCount = 1;
          if (crossAxisCount > 4) crossAxisCount = 4; // Max 4 columns

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2 / 3, // Card aspect ratio
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FindDetailPage(user: user),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          // In a real app, you would use a NetworkImage here
                          child: Icon(Icons.person, size: 40),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user['name']!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user['position']!,
                          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Text(
                            user['introduction']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
