import 'package:flutter/material.dart';

class SetAlarmScreen extends StatefulWidget {
  const SetAlarmScreen({super.key});

  @override
  State<SetAlarmScreen> createState() => _SetAlarmScreenState();
}

class _SetAlarmScreenState extends State<SetAlarmScreen> {
  String selectedDifficulty = '쉬움';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새로운 던전 탐색(알람 추가)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 시간 설정 UI (가짜 UI)
            const Text('기상 시간', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '07 : 00 AM',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(height: 32),
            const Text('반복 요일', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['월', '화', '수', '목', '금', '토', '일'].map((day) {
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: ['토', '일'].contains(day) ? Colors.grey[800] : Theme.of(context).primaryColor,
                  child: Text(day, style: const TextStyle(color: Colors.white)),
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
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('던전 생성 (저장)'),
            )
          ],
        ),
      ),
    );
  }
}
