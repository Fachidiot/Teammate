import 'package:flutter/material.dart';

class TeamDetailPage extends StatelessWidget {
  const TeamDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('팀 상세 정보'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 700;
          if (isWideScreen) {
            return _buildWideLayout(context);
          } else {
            return _buildNarrowLayout(context);
          }
        }),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildTeamInfo(context),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: _buildMemberList(context),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTeamInfo(context),
        const SizedBox(height: 24),
        _buildMemberList(context),
      ],
    );
  }

  Widget _buildTeamInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '[프로젝트] 팀원 모집합니다',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            CircleAvatar(radius: 12, child: Icon(Icons.person, size: 16)),
            SizedBox(width: 8),
            Text('팀 리더 이름', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 16),
            Icon(Icons.location_on, size: 16, color: Colors.grey),
            SizedBox(width: 4),
            Text('서울', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const Divider(height: 48),
        const Text(
          '프로젝트 설명',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Flutter를 사용하여 멋진 팀원 관리 앱을 만들고 있습니다. ' 
          '디자이너 1명, 기획자 1명을 추가로 모집하고 있습니다. ' 
          '함께 성장하고 멋진 포트폴리오를 만들고 싶으신 분들의 많은 지원 바랍니다. ' 
          '주 1회 오프라인, 주 2회 온라인으로 회의를 진행합니다.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const Divider(height: 48),
        const Text(
          '모집 포지션',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            Chip(label: const Text('#디자이너'), backgroundColor: Colors.lightBlue.shade100),
            Chip(label: const Text('#기획자'), backgroundColor: Colors.lightGreen.shade100),
            Chip(label: const Text('#Flutter'), backgroundColor: Colors.orange.shade100),
          ],
        )
      ],
    );
  }

  Widget _buildMemberList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '참여중인 멤버 (3/5)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ...List.generate(3, (index) => ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text('멤버 ${index + 1}'),
            subtitle: Text(['개발자', '개발자', '디자이너'][index]),
          )),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('참여 요청하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
