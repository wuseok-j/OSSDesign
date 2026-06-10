import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alarm/alarm.dart';
class AlarmRingingScreen extends StatefulWidget {
  const AlarmRingingScreen({super.key});

  @override
  State<AlarmRingingScreen> createState() => _AlarmRingingScreenState();
}

class _AlarmRingingScreenState extends State<AlarmRingingScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  String currentTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) _updateTime();
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });
  }

  void _turnOffAlarm() {
    // 여기서 알람을 끄지 않고 전투 화면으로 넘어갑니다. (전투 종료 시까지 소리/진동 유지)
    Navigator.pushReplacementNamed(context, '/battle');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      Alarm.stopAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final color = Color.lerp(Colors.black, const Color(0xFF3B0000), _animationController.value);
            return Container(
              color: color,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.alarm_on, size: 80, color: Colors.redAccent),
                  const SizedBox(height: 24),
                  Text(
                    currentTime,
                    style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '일어나세요! 몬스터가 나타났습니다!',
                    style: TextStyle(fontSize: 20, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 64),
                  ElevatedButton(
                    onPressed: _turnOffAlarm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                      elevation: 10,
                    ),
                    child: const Text(
                      '알람 끄기 (전투 돌입)',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
          ),
        ),
      ),
    );
  }
}
