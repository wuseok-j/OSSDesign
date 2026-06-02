import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/battle_provider.dart';

class SuccessScreen extends ConsumerWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 120, color: Colors.amber),
              const SizedBox(height: 24),
              const Text(
                '던전 클리어!',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.amber),
              ),
              const SizedBox(height: 16),
              const Text(
                '아침을 깨우는 데 성공하셨습니다!\n경험치 +50 EXP\n골드 +100 G',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  // 전투 상태 초기화 및 홈으로 이동
                  ref.read(battleProvider.notifier).resetBattle(100);
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text('마을(홈)로 돌아가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
