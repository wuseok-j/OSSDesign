import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/monster_model.dart';

class MonsterState {
  final MonsterModel monster;
  final int currentHp;
  final bool isDefeated;

  MonsterState({
    required this.monster,
    required this.currentHp,
    this.isDefeated = false,
  });

  MonsterState copyWith({int? currentHp, bool? isDefeated, MonsterModel? monster}) {
    return MonsterState(
      monster: monster ?? this.monster,
      currentHp: currentHp ?? this.currentHp,
      isDefeated: isDefeated ?? this.isDefeated,
    );
  }
}

class BattleNotifier extends StateNotifier<MonsterState> {
  BattleNotifier() : super(MonsterState(
    monster: MonsterDictionary.snoozeDevil,
    currentHp: MonsterDictionary.snoozeDevil.maxHp,
  ));

  void attack(int damage) {
    if (state.isDefeated) return;

    final newHp = state.currentHp - damage;
    if (newHp <= 0) {
      state = state.copyWith(currentHp: 0, isDefeated: true);
    } else {
      state = state.copyWith(currentHp: newHp);
    }
  }

  void resetBattle(String difficulty) {
    MonsterModel selectedMonster;
    final random = Random();

    switch (difficulty) {
      case '쉬움':
        selectedMonster = MonsterDictionary.snoozeDevil;
        break;
      case '보통':
        selectedMonster = random.nextBool() 
            ? MonsterDictionary.sleepFogCreeper 
            : MonsterDictionary.duvetHellSlime;
        break;
      case '어려움':
      case '지옥': // just in case
        selectedMonster = MonsterDictionary.secondSleepSummoner;
        break;
      default:
        selectedMonster = MonsterDictionary.snoozeDevil;
    }

    state = MonsterState(
      monster: selectedMonster,
      currentHp: selectedMonster.maxHp,
      isDefeated: false,
    );
  }
}

final battleProvider = StateNotifierProvider<BattleNotifier, MonsterState>((ref) {
  return BattleNotifier();
});
