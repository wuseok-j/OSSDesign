import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';
import 'features/alarm_setup/set_alarm_screen.dart';
import 'features/battle/mission_execution_screen.dart';
import 'features/result/success_screen.dart';
import 'features/profile/character_info_screen.dart';

void main() {
  runApp(const ProviderScope(child: AlarmDungeonApp()));
}

class AlarmDungeonApp extends StatelessWidget {
  const AlarmDungeonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Dungeon',
      theme: DungeonTheme.themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/set_alarm': (context) => const SetAlarmScreen(),
        '/battle': (context) => const MissionExecutionScreen(),
        '/result': (context) => const SuccessScreen(),
        '/profile': (context) => const CharacterInfoScreen(),
      },
    );
  }
}
