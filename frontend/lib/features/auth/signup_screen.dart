import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void _handleSignup() async {
    final id = _idController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    if (id.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디, 비밀번호, 캐릭터 이름을 모두 입력해주세요.')),
      );
      return;
    }

    final success = await ref.read(authProvider.notifier).signup(id, password, name);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입이 완료되었습니다. 로그인 해주세요.')),
      );
      if (mounted) {
        Navigator.pop(context); // 로그인 화면으로 돌아가기
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 존재하는 아이디입니다.')),
      );
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새로운 용사 등록'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40), // 스크롤 여유 공간
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2D2D44),
                    hintText: '사용할 아이디 (ID)',
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
                    hintText: '사용할 비밀번호',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2D2D44),
                    hintText: '사용할 용사 이름 (캐릭터명)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _handleSignup,
                  child: const Text('용사 등록하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
