import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/providers/auth_provider.dart';
import '../../domain/providers/alarm_provider.dart';
import '../../domain/models/alarm_model.dart';
import '../../domain/providers/battle_provider.dart';
import '../alarm_setup/set_alarm_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestPermissions();
    });
  }

  Future<void> _checkAndRequestPermissions() async {
    final isAlertGranted = await Permission.systemAlertWindow.isGranted;
    if (!isAlertGranted) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2D2D44),
            title: const Text('필수 권한 안내', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: const Text(
              '화면이 꺼진 상태에서도 알람이 울리면 자동으로 화면이 켜지고 몬스터가 나오게 하려면 "다른 앱 위에 표시" 권한이 반드시 필요합니다.\n\n확인을 누르시면 스마트폰 설정 화면으로 이동합니다. 목록에서 "Alarm Dungeon"을 찾아 꼭 켜주세요!',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('취소', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Permission.systemAlertWindow.request();
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A826)),
                child: const Text('확인 (설정으로 이동)', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final alarms = ref.watch(alarmProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ALARM DUNGEON'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
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
                        children: [
                          Text('용사 ${user?.characterName ?? '알수없음'}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('LV. ${user?.level ?? 1} (${user?.characterClass ?? '초보자'})', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 권한 설정 안내 배너
            Card(
              color: const Color(0xFFF9A826).withOpacity(0.2),
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFFF9A826), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.warning_amber_rounded, color: Color(0xFFF9A826), size: 36),
                title: const Text('알람 화면이 자동으로 켜지지 않나요?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('안드로이드 보안 설정 때문에 알람이 상단바에만 뜰 수 있습니다. 여기를 눌러 전체 화면 알림 권한을 허용해주세요.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                onTap: () async {
                  if (Platform.isAndroid) {
                    const intent = AndroidIntent(
                      action: 'android.settings.MANAGE_APP_USE_FULL_SCREEN_INTENT',
                      data: 'package:com.example.alarm_dungeon',
                    );
                    try {
                      await intent.launch();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('설정 화면을 열 수 없습니다. 앱 정보에서 직접 설정해주세요.')),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '설정된 알람 던전',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 알람 리스트
            Expanded(
              child: alarms.isEmpty
                  ? const Center(child: Text('설정된 던전이 없습니다.\n우측 하단의 + 버튼을 눌러 던전을 생성하세요.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = alarms[index];
                        return _buildAlarmCard(context, ref, alarm);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_btn',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SetAlarmScreen()),
          );
        },
        backgroundColor: const Color(0xFFF9A826),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildAlarmCard(BuildContext context, WidgetRef ref, AlarmModel alarm) {
    final timeStr = '${alarm.hour > 12 ? '오후' : '오전'} ${alarm.hour > 12 ? alarm.hour - 12 : alarm.hour}:${alarm.minute.toString().padLeft(2, '0')}';
    final daysStr = alarm.activeDays.join(' ');

    return Card(
      color: const Color(0xFF2D2D44),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(timeStr, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: alarm.isActive ? Colors.white : Colors.grey)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(daysStr, style: TextStyle(color: alarm.isActive ? Colors.white70 : Colors.grey)),
            Text('난이도: ${alarm.difficulty}', style: TextStyle(color: alarm.isActive ? const Color(0xFFE63946) : Colors.grey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: alarm.isActive,
              onChanged: (val) {
                ref.read(alarmProvider.notifier).toggleAlarm(alarm.id);
              },
              activeColor: const Color(0xFFF9A826),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                ref.read(alarmProvider.notifier).deleteAlarm(alarm.id);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetAlarmScreen(alarmToEdit: alarm),
            ),
          );
        },
      ),
    );
  }
}
