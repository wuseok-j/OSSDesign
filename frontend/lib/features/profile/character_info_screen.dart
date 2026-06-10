import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/auth_provider.dart';
import 'monster_dictionary_screen.dart';

class CharacterInfoScreen extends ConsumerWidget {
  const CharacterInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('로그인이 필요합니다.')),
      );
    }

    final double avgWakeUpTime = user.clearTimeSeconds.isNotEmpty
        ? user.clearTimeSeconds.reduce((a, b) => a + b) / user.clearTimeSeconds.length
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('용사 프로필'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  '용사 ${user.characterName}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  '직업: ${user.characterClass}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                Card(
                  color: const Color(0xFF2D2D44),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildStatRow('레벨', '${user.level}'),
                        const Divider(color: Colors.grey),
                        _buildStatRow('경험치', '${user.exp} / ${user.level * 100}'),
                        const Divider(color: Colors.grey),
                        _buildStatRow('토벌한 몬스터 수', '${user.monsterKills} 마리'),
                        const Divider(color: Colors.grey),
                        _buildStatRow('평균 기상(클리어) 소요 시간', '${avgWakeUpTime.toStringAsFixed(1)} 초'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32), // Spacer 대신 고정 여백 사용
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MonsterDictionaryScreen()),
                );
              },
              icon: const Icon(Icons.book),
              label: const Text('몬스터 도감 보기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
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
