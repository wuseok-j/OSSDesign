import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../domain/models/alarm_model.dart';
import '../../domain/providers/alarm_provider.dart';

class SetAlarmScreen extends ConsumerStatefulWidget {
  final AlarmModel? alarmToEdit;
  const SetAlarmScreen({super.key, this.alarmToEdit});

  @override
  ConsumerState<SetAlarmScreen> createState() => _SetAlarmScreenState();
}

class _SetAlarmScreenState extends ConsumerState<SetAlarmScreen> {
  String selectedDifficulty = '쉬움';
  TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 0);
  final List<String> _days = ['월', '화', '수', '목', '금', '토', '일'];
  final Set<String> _selectedDays = {'월', '화', '수', '목', '금'};

  @override
  void initState() {
    super.initState();
    if (widget.alarmToEdit != null) {
      selectedDifficulty = widget.alarmToEdit!.difficulty;
      selectedTime = TimeOfDay(hour: widget.alarmToEdit!.hour, minute: widget.alarmToEdit!.minute);
      _selectedDays.clear();
      _selectedDays.addAll(widget.alarmToEdit!.activeDays);
    }
  }

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _saveAlarm() {
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('반복할 요일을 하나 이상 선택해주세요.')),
      );
      return;
    }

    if (widget.alarmToEdit != null) {
      final updatedAlarm = widget.alarmToEdit!.copyWith(
        hour: selectedTime.hour,
        minute: selectedTime.minute,
        activeDays: _selectedDays.toList()..sort((a, b) => _days.indexOf(a).compareTo(_days.indexOf(b))),
        difficulty: selectedDifficulty,
        isActive: true, // 수정 시 기본적으로 활성화
      );
      ref.read(alarmProvider.notifier).updateAlarm(updatedAlarm);
    } else {
      final newAlarm = AlarmModel(
        id: DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(1000).toString(),
        hour: selectedTime.hour,
        minute: selectedTime.minute,
        activeDays: _selectedDays.toList()..sort((a, b) => _days.indexOf(a).compareTo(_days.indexOf(b))),
        difficulty: selectedDifficulty,
      );
      ref.read(alarmProvider.notifier).addAlarm(newAlarm);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final timeStr = '${selectedTime.hour.toString().padLeft(2, '0')} : ${selectedTime.minute.toString().padLeft(2, '0')}';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarmToEdit != null ? '던전 정보 수정' : '새로운 던전 탐색(알람 추가)'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('기상 시간', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickTime,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D44),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        timeStr,
                        style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('반복 요일', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _days.map((day) {
                    final isSelected = _selectedDays.contains(day);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedDays.remove(day);
                          } else {
                            _selectedDays.add(day);
                          }
                        });
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
                        child: Text(day, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                const Text('던전(몬스터) 난이도', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedDifficulty,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2D2D44),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                  items: ['쉬움', '보통', '어려움'].map((level) {
                    return DropdownMenuItem(value: level, child: Text(level));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedDifficulty = val);
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0),
          child: ElevatedButton(
            onPressed: _saveAlarm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(widget.alarmToEdit != null ? '수정 완료' : '던전 생성 (저장)'),
          ),
        ),
      ),
    );
  }
}
