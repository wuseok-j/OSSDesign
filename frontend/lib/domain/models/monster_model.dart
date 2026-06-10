class MonsterModel {
  final String id;
  final String name;
  final String englishName;
  final String description;
  final String difficulty;
  final int maxHp;
  final String imagePath;

  const MonsterModel({
    required this.id,
    required this.name,
    required this.englishName,
    required this.description,
    required this.difficulty,
    required this.maxHp,
    required this.imagePath,
  });
}

class MonsterDictionary {
  static const snoozeDevil = MonsterModel(
    id: 'm1',
    name: '스누즈 데빌',
    englishName: 'Snooze Devil',
    description: '계속해서 알람을 미루게 만드는 유혹의 몬스터입니다.',
    difficulty: '쉬움',
    maxHp: 100,
    imagePath: 'assets/images/monster/Snooze Devil.png',
  );

  static const sleepFogCreeper = MonsterModel(
    id: 'm2',
    name: '수면 안개 크리퍼',
    englishName: 'Sleep Fog Creeper',
    description: '뇌가 멍한 상태를 유지시켜 침대 밖으로 나오지 못하게 합니다.',
    difficulty: '보통',
    maxHp: 200,
    imagePath: 'assets/images/monster/Sleep Fog Creeper.png',
  );

  static const duvetHellSlime = MonsterModel(
    id: 'm3',
    name: '이불 지옥 슬라임',
    englishName: 'Duvet Hell Slime',
    description: '물리적인 몸의 피로와 침대의 편안함을 이용하여 기상을 방해합니다.',
    difficulty: '보통',
    maxHp: 300,
    imagePath: 'assets/images/monster/Duvet Hell Slime.png',
  );

  static const secondSleepSummoner = MonsterModel(
    id: 'm4',
    name: '2차 수면 소환사',
    englishName: 'Second Sleep Summoner',
    description: '알람을 끄고 잠시 안심한 틈을 타 다시 깊은 잠에 빠지게 만드는 강력한 최종 보스급 몬스터입니다.',
    difficulty: '어려움',
    maxHp: 500,
    imagePath: 'assets/images/monster/Second Sleep Summoner.png',
  );

  static const List<MonsterModel> allMonsters = [
    snoozeDevil,
    sleepFogCreeper,
    duvetHellSlime,
    secondSleepSummoner,
  ];
}
