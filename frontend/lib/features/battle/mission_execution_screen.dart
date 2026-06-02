import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/battle_provider.dart';

class MissionExecutionScreen extends ConsumerWidget {
  const MissionExecutionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monsterState = ref.watch(battleProvider);

    // 몬스터가 쓰러졌을 때 결과 화면으로 자동 이동
    ref.listen<MonsterState>(battleProvider, (previous, next) {
      if (next.isDefeated) {
        // 약간의 지연 후 결과 화면으로 이동
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(context, '/result');
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.black, // 어두운 던전 느낌
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              '⚠️ 알람 발생! 몬스터 출현! ⚠️',
              style: TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // 몬스터 체력 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Text('드래곤 HP: ${monsterState.currentHp} / ${monsterState.maxHp}',
                      style: const TextStyle(fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: monsterState.currentHp / monsterState.maxHp,
                    backgroundColor: Colors.grey[800],
                    color: Colors.red,
                    minHeight: 20,
                  ),
                ],
              ),
            ),
            const Spacer(),
            // 가짜 몬스터 이미지 영역 (실제로는 pixel 아트 에셋 사용 예정)
            Icon(
              monsterState.isDefeated ? Icons.mood_bad : Icons.adb, // 임시 아이콘
              size: 150,
              color: monsterState.isDefeated ? Colors.grey : Colors.greenAccent,
            ),
            const Spacer(),
            // 공격(미션) 버튼
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '스마트폰을 마구 흔들거나 수학 문제를 푸세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // 임시로 버튼 클릭 시 데미지(20)를 입히도록 설정
                      ref.read(battleProvider.notifier).attack(20);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                    ),
                    child: const Text('공격하기! (데미지 20)', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
