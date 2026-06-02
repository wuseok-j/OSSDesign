import 'package:flutter/material.dart';

class CharacterInfoScreen extends StatelessWidget {
  const CharacterInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('용사 프로필'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              '용사 우석',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              '직업: 기사',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Card(
              color: const Color(0xFF2D2D44),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatRow('레벨', '5'),
                    const Divider(color: Colors.grey),
                    _buildStatRow('경험치', '250 / 500'),
                    const Divider(color: Colors.grey),
                    _buildStatRow('보유 골드', '1,200 G'),
                    const Divider(color: Colors.grey),
                    _buildStatRow('토벌한 몬스터 수', '12 마리'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // 상점 이동 (향후 구현)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('상점 기능은 준비 중입니다.')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('상점 가기'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
