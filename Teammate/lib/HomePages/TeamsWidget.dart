import 'package:flutter/material.dart';
import 'package:teammate/HomePages/TeamDetailPage.dart';

class TeamsWidget extends StatelessWidget {
  const TeamsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 찾기'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine the number of columns based on the screen width.
          int crossAxisCount = (constraints.maxWidth / 300).floor();
          if (crossAxisCount < 1) crossAxisCount = 1;

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3 / 2, // Adjust aspect ratio as needed
            ),
            itemCount: 10, // Replace with your actual team count
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeamDetailPage(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '[프로젝트] 팀원 모집합니다', 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text('현재 3/5명 참여중'),
                        Spacer(),
                        Row(
                          children: [
                            Icon(Icons.person_pin_circle_outlined, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text('서울', style: TextStyle(color: Colors.grey)),
                            Spacer(),
                            Text('1일 전', style: TextStyle(color: Colors.grey)),
                          ],
                        )
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
