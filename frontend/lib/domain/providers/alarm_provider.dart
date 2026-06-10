import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:alarm/alarm.dart';
import '../models/alarm_model.dart';
import 'auth_provider.dart';

final alarmProvider = StateNotifierProvider<AlarmNotifier, List<AlarmModel>>((ref) {
  final user = ref.watch(authProvider);
  return AlarmNotifier(user?.id);
});

class AlarmNotifier extends StateNotifier<List<AlarmModel>> {
  final String? userId;

  AlarmNotifier(this.userId) : super([]) {
    if (userId != null) {
      _loadAlarms();
    }
  }

  String get _storageKey => 'alarms_$userId';

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alarmsJson = prefs.getString(_storageKey);
    if (alarmsJson != null) {
      final List<dynamic> decoded = json.decode(alarmsJson);
      state = decoded.map((e) => AlarmModel.fromJson(e)).toList();
    }
  }

  Future<void> _saveAlarms(List<AlarmModel> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded = alarms.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(encoded));
  }

  DateTime _getNextAlarmTime(int hour, int minute) {
    final now = DateTime.now();
    DateTime next = DateTime(now.year, now.month, now.day, hour, minute);
    if (next.isBefore(now)) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }

  Future<void> _scheduleNativeAlarm(AlarmModel alarm) async {
    if (!alarm.isActive) return;
    final alarmSettings = AlarmSettings(
      id: alarm.id.hashCode,
      dateTime: _getNextAlarmTime(alarm.hour, alarm.minute),
      assetAudioPath: 'assets/audio/alarm.wav',
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: true,
      volumeSettings: const VolumeSettings.fixed(volume: 1.0),
      androidFullScreenIntent: true,
      notificationSettings: const NotificationSettings(
        title: '알람 던전',
        body: '기상 미션! 몬스터가 출현했습니다!',
      ),
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  Future<void> _cancelNativeAlarm(AlarmModel alarm) async {
    await Alarm.stop(alarm.id.hashCode);
  }

  void addAlarm(AlarmModel alarm) {
    state = [...state, alarm];
    _saveAlarms(state);
    _scheduleNativeAlarm(alarm);
  }

  void toggleAlarm(String id) {
    state = state.map((a) {
      if (a.id == id) {
        final toggled = a.copyWith(isActive: !a.isActive);
        if (toggled.isActive) {
          _scheduleNativeAlarm(toggled);
        } else {
          _cancelNativeAlarm(toggled);
        }
        return toggled;
      }
      return a;
    }).toList();
    _saveAlarms(state);
  }

  void deleteAlarm(String id) {
    final alarm = state.firstWhere((a) => a.id == id);
    _cancelNativeAlarm(alarm);
    state = state.where((a) => a.id != id).toList();
    _saveAlarms(state);
  }

  void updateAlarm(AlarmModel alarm) {
    state = state.map((a) => a.id == alarm.id ? alarm : a).toList();
    _saveAlarms(state);
    if (alarm.isActive) {
      _scheduleNativeAlarm(alarm);
    } else {
      _cancelNativeAlarm(alarm);
    }
  }
}
