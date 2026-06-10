import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarm/alarm.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

import 'core/theme.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/home/home_screen.dart';
import 'features/alarm_setup/set_alarm_screen.dart';
import 'features/battle/mission_execution_screen.dart';
import 'features/result/success_screen.dart';
import 'features/profile/character_info_screen.dart';
import 'features/alarm_ringing/alarm_ringing_screen.dart';
import 'domain/providers/auth_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  
  runApp(const ProviderScope(child: AlarmDungeonApp()));
}

class AlarmDungeonApp extends StatefulWidget {
  const AlarmDungeonApp({super.key});

  @override
  State<AlarmDungeonApp> createState() => _AlarmDungeonAppState();
}

class _AlarmDungeonAppState extends State<AlarmDungeonApp> {
  StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    subscription = Alarm.ringStream.stream.listen((alarmSettings) {
      navigatorKey.currentState?.pushNamed('/ringing');
    });
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.systemAlertWindow,
      Permission.notification,
      Permission.scheduleExactAlarm,
    ].request();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Alarm Dungeon',
      theme: DungeonTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(authProvider);
          return user == null ? const LoginScreen() : const HomeScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/set_alarm': (context) => const SetAlarmScreen(),
        '/battle': (context) => const MissionExecutionScreen(),
        '/result': (context) => const SuccessScreen(),
        '/profile': (context) => const CharacterInfoScreen(),
        '/ringing': (context) => const AlarmRingingScreen(),
      },
    );
  }
}
