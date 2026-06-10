import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

// 현재 로그인된 유저 상태
final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(null) {
    _loadUser();
  }

  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user_id';

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getString(_currentUserKey);
    if (currentUserId != null) {
      final users = _getUsers(prefs);
      final user = users.firstWhere((u) => u.id == currentUserId, orElse: () => UserModel(id: '', password: '', characterName: ''));
      if (user.id.isNotEmpty) {
        state = user;
      }
    }
  }

  List<UserModel> _getUsers(SharedPreferences prefs) {
    final String? usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return [];
    
    final List<dynamic> decoded = json.decode(usersJson);
    return decoded.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<void> _saveUsers(List<UserModel> users, SharedPreferences prefs) async {
    final encoded = json.encode(users.map((e) => e.toJson()).toList());
    await prefs.setString(_usersKey, encoded);
  }

  Future<bool> signup(String id, String password, String characterName) async {
    final prefs = await SharedPreferences.getInstance();
    final users = _getUsers(prefs);

    // 중복 체크
    if (users.any((u) => u.id == id)) {
      return false; // 이미 존재하는 아이디
    }

    final newUser = UserModel(
      id: id, 
      password: password, 
      characterName: characterName,
      level: 1,
      exp: 0,
      monsterKills: 0,
      clearTimeSeconds: [],
    );
    users.add(newUser);
    
    await _saveUsers(users, prefs);
    return true;
  }

  Future<bool> login(String id, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = _getUsers(prefs);

    try {
      final user = users.firstWhere((u) => u.id == id && u.password == password);
      await prefs.setString(_currentUserKey, user.id);
      state = user;
      return true;
    } catch (e) {
      return false; // 로그인 실패
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    state = null;
  }

  Future<void> updateCharacterStats(int expGain, int clearTime) async {
    if (state == null) return;

    final prefs = await SharedPreferences.getInstance();
    final users = _getUsers(prefs);
    final userIndex = users.indexWhere((u) => u.id == state!.id);

    if (userIndex != -1) {
      int currentExp = state!.exp + expGain;
      int currentLevel = state!.level;
      
      // 레벨업 로직: 레벨 * 100 경험치 도달 시 1레벨 상승
      while (currentExp >= currentLevel * 100) {
        currentExp -= currentLevel * 100;
        currentLevel++;
      }

      final updatedClearTimeList = List<int>.from(state!.clearTimeSeconds)..add(clearTime);

      final updatedUser = UserModel(
        id: state!.id,
        password: state!.password,
        characterName: state!.characterName,
        characterClass: state!.characterClass,
        level: currentLevel,
        exp: currentExp,
        monsterKills: state!.monsterKills + 1,
        clearTimeSeconds: updatedClearTimeList,
      );

      users[userIndex] = updatedUser;
      await _saveUsers(users, prefs);
      state = updatedUser;
    }
  }
}
