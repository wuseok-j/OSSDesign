import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() async {
    final id = _idController.text.trim();
    final password = _passwordController.text;

    if (id.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디와 비밀번호를 모두 입력해주세요.')),
      );
      return;
    }

    final success = await ref.read(authProvider.notifier).login(id, password);
    if (success) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('아이디 또는 비밀번호가 틀렸습니다. (혹은 가입되지 않은 아이디)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60), // 스크롤 여유 공간
                const Icon(
                  Icons.shield,
                  size: 100,
                  color: Color(0xFFF9A826), // Primary Color
                ),
                const SizedBox(height: 24),
                const Text(
                  'ALARM DUNGEON',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                    shadows: [
                      Shadow(
                        offset: Offset(3.0, 3.0),
                        blurRadius: 0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '던전에 입장하여 무의식과 싸우세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2D2D44),
                    hintText: '용사 이름 (ID)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2D2D44),
                    hintText: '비밀번호',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('던전 입장하기'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    '처음 오셨나요? 새로운 용사 등록',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
