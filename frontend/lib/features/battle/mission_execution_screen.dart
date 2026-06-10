import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:alarm/alarm.dart';
import '../../domain/providers/battle_provider.dart';
import '../../domain/providers/auth_provider.dart';

enum MissionType { easyMath, hardMath, commonSense, tapAction }

class MissionExecutionScreen extends ConsumerStatefulWidget {
  const MissionExecutionScreen({super.key});

  @override
  ConsumerState<MissionExecutionScreen> createState() => _MissionExecutionScreenState();
}

class _MissionExecutionScreenState extends ConsumerState<MissionExecutionScreen> with WidgetsBindingObserver {
  late DateTime _startTime;
  MissionType currentMission = MissionType.easyMath;

  // Math variables
  int num1 = 0;
  int num2 = 0;
  final TextEditingController _answerController = TextEditingController();

  // Common Sense variables
  String question = '';
  List<String> options = [];
  int correctOptionIndex = 0;

  // Tap Action variables
  int tapCount = 0;
  final int requiredTaps = 20;

  String errorMessage = '';

  final List<Map<String, dynamic>> _commonSenseQuizzes = [
    {
      'q': '다음 중 세계에서 가장 큰 대양은?',
      'options': ['대서양', '인도양', '태평양', '북극해'],
      'a': 2
    },
    {
      'q': '광합성을 통해 식물이 만들어내는 기체는?',
      'options': ['이산화탄소', '산소', '질소', '수소'],
      'a': 1
    },
    {
      'q': '1년 중 가장 밤이 긴 절기는?',
      'options': ['동지', '하지', '춘분', '추분'],
      'a': 0
    },
    {
      'q': '대한민국의 국보 1호는?',
      'options': ['숭례문', '흥인지문', '경복궁', '불국사'],
      'a': 0
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _startTime = DateTime.now();
    _generateNextMission();
  }

  void _generateNextMission() {
    final random = Random();
    // 미션 종류 랜덤 선택
    final missionValues = MissionType.values;
    currentMission = missionValues[random.nextInt(missionValues.length)];

    errorMessage = '';
    _answerController.clear();

    switch (currentMission) {
      case MissionType.easyMath:
        num1 = random.nextInt(20) + 1;
        num2 = random.nextInt(20) + 1;
        break;
      case MissionType.hardMath:
        num1 = random.nextInt(50) + 50;
        num2 = random.nextInt(50) + 50;
        break;
      case MissionType.commonSense:
        final q = _commonSenseQuizzes[random.nextInt(_commonSenseQuizzes.length)];
        question = q['q'];
        options = List<String>.from(q['options']);
        correctOptionIndex = q['a'];
        break;
      case MissionType.tapAction:
        tapCount = 0;
        break;
    }
    setState(() {});
  }

  void _handleSuccess(int damage) {
    ref.read(battleProvider.notifier).attack(damage);
    
    // 몬스터 체력 체크
    final isDefeated = ref.read(battleProvider).isDefeated;
    if (isDefeated) {
      final int clearTime = DateTime.now().difference(_startTime).inSeconds;
      ref.read(authProvider.notifier).updateCharacterStats(50, clearTime);
      Alarm.stopAll(); // 전투 승리 시 알람 종료
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(context, '/result');
      });
    } else {
      // 안 죽었으면 다음 미션
      _generateNextMission();
    }
  }

  void _handleFailure() {
    setState(() {
      errorMessage = '틀렸습니다! 다시 시도하세요!';
      _answerController.clear();
    });
  }

  void _checkMathAnswer() {
    final input = int.tryParse(_answerController.text.trim());
    if (input == num1 + num2) {
      _handleSuccess(currentMission == MissionType.easyMath ? 20 : 50);
    } else {
      _handleFailure();
    }
  }

  void _checkQuizAnswer(int index) {
    if (index == correctOptionIndex) {
      _handleSuccess(100);
    } else {
      _handleFailure();
    }
  }

  void _handleTap() {
    setState(() {
      tapCount++;
      if (tapCount >= requiredTaps) {
        _handleSuccess(30);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _answerController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      Alarm.stopAll();
    }
  }

  Widget _buildMissionWidget() {
    switch (currentMission) {
      case MissionType.easyMath:
      case MissionType.hardMath:
        final title = currentMission == MissionType.easyMath ? '쉬운 수학 문제 (데미지 20)' : '어려운 수학 문제 (데미지 50)';
        return Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            Text('$num1 + $num2 = ?', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _answerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 24),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: '정답 입력',
              ),
              onSubmitted: (_) => _checkMathAnswer(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkMathAnswer,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('공격하기!'),
            ),
          ],
        );
      case MissionType.commonSense:
        return Column(
          children: [
            const Text('상식 퀴즈 (데미지 100)', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            Text(question, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ...List.generate(options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () => _checkQuizAnswer(index),
                  child: Text(options[index]),
                ),
              );
            }),
          ],
        );
      case MissionType.tapAction:
        return Column(
          children: [
            const Text('잠깨기 연타! (데미지 30)', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            Text('터치 $tapCount / $requiredTaps', style: const TextStyle(color: Colors.amber, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _handleTap,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 20)],
                ),
                child: const Center(
                  child: Text('연타!', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final monsterState = ref.watch(battleProvider);
    final monster = monsterState.monster;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            children: [
              Text(
                '⚠️ ${monster.name} 출현! ⚠️',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text('HP: ${monsterState.currentHp} / ${monster.maxHp}', style: const TextStyle(fontSize: 18, color: Colors.white)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: monsterState.currentHp / monster.maxHp,
                      backgroundColor: Colors.grey[800],
                      color: Colors.red,
                      minHeight: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                monster.imagePath,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.mood_bad, size: 120, color: Colors.grey);
                },
              ),
              const SizedBox(height: 20),
              Card(
                color: const Color(0xFF2D2D44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMissionWidget(),
                      if (errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
