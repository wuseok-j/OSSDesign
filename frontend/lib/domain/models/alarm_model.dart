import 'dart:convert';

class AlarmModel {
  final String id;
  final int hour;
  final int minute;
  final List<String> activeDays;
  final String difficulty;
  final bool isActive;

  AlarmModel({
    required this.id,
    required this.hour,
    required this.minute,
    required this.activeDays,
    required this.difficulty,
    this.isActive = true,
  });

  AlarmModel copyWith({
    String? id,
    int? hour,
    int? minute,
    List<String>? activeDays,
    String? difficulty,
    bool? isActive,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      activeDays: activeDays ?? this.activeDays,
      difficulty: difficulty ?? this.difficulty,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'activeDays': activeDays,
      'difficulty': difficulty,
      'isActive': isActive,
    };
  }

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['id'],
      hour: map['hour'],
      minute: map['minute'],
      activeDays: List<String>.from(map['activeDays']),
      difficulty: map['difficulty'],
      isActive: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AlarmModel.fromJson(String source) => AlarmModel.fromMap(json.decode(source));
}
