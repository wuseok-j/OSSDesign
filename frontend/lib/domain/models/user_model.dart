class UserModel {
  final String id;
  final String password;
  final String characterName;
  final int level;
  final String characterClass;
  final int exp;
  final int monsterKills;
  final List<int> clearTimeSeconds;

  UserModel({
    required this.id,
    required this.password,
    required this.characterName,
    this.level = 1,
    this.characterClass = '초보자',
    this.exp = 0,
    this.monsterKills = 0,
    this.clearTimeSeconds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'characterName': characterName,
      'level': level,
      'characterClass': characterClass,
      'exp': exp,
      'monsterKills': monsterKills,
      'clearTimeSeconds': clearTimeSeconds,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      password: json['password'],
      characterName: json['characterName'] ?? json['id'], // 호환성을 위해 이름이 없으면 id 사용
      level: json['level'] ?? 1,
      characterClass: json['characterClass'] ?? '초보자',
      exp: json['exp'] ?? 0,
      monsterKills: json['monsterKills'] ?? 0,
      clearTimeSeconds: json['clearTimeSeconds'] != null 
          ? List<int>.from(json['clearTimeSeconds']) 
          : [],
    );
  }
}
