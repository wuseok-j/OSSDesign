import 'package:flutter_riverpod/flutter_riverpod.dart';

// 몬스터의 상태를 나타내는 클래스
class MonsterState {
  final int maxHp;
  final int currentHp;
  final bool isDefeated;

  MonsterState({
    required this.maxHp,
    required this.currentHp,
    this.isDefeated = false,
  });

  MonsterState copyWith({int? currentHp, bool? isDefeated}) {
    return MonsterState(
      maxHp: maxHp,
      currentHp: currentHp ?? this.currentHp,
      isDefeated: isDefeated ?? this.isDefeated,
    );
  }
}

// 몬스터의 체력과 전투 로직을 관리하는 Provider
class BattleNotifier extends StateNotifier<MonsterState> {
  BattleNotifier() : super(MonsterState(maxHp: 100, currentHp: 100));

  void attack(int damage) {
    if (state.isDefeated) return;

    final newHp = state.currentHp - damage;
    if (newHp <= 0) {
      state = state.copyWith(currentHp: 0, isDefeated: true);
    } else {
      state = state.copyWith(currentHp: newHp);
    }
  }

  void resetBattle(int newMaxHp) {
    state = MonsterState(maxHp: newMaxHp, currentHp: newMaxHp);
  }
}

final battleProvider = StateNotifierProvider<BattleNotifier, MonsterState>((ref) {
  return BattleNotifier();
});
