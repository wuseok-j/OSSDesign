import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALARM DUNGEON'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 내 캐릭터 상태 요약 카드
            Card(
              color: const Color(0xFF2D2D44),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('용사 우석', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('LV. 5 (기사)', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '설정된 알람 던전',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 알람 리스트 (하드코딩 예시)
            Expanded(
              child: ListView(
                children: [
                  _buildAlarmCard(context, '오전 7:00', '월 화 수 목 금', '쉬움 (슬라임)', true),
                  _buildAlarmCard(context, '오전 8:30', '주말', '어려움 (드래곤)', false),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/set_alarm');
        },
        backgroundColor: const Color(0xFFF9A826),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildAlarmCard(BuildContext context, String time, String days, String difficulty, bool isActive) {
    return Card(
      color: const Color(0xFF2D2D44),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(time, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(days, style: const TextStyle(color: Colors.grey)),
            Text('난이도: $difficulty', style: const TextStyle(color: Color(0xFFE63946))),
          ],
        ),
        trailing: Switch(
          value: isActive,
          onChanged: (val) {},
          activeColor: const Color(0xFFF9A826),
        ),
        onTap: () {
          // 데모 시연을 위해 알람 탭 시 바로 전투 화면으로 이동
          Navigator.pushNamed(context, '/battle');
        },
      ),
    );
  }
}
