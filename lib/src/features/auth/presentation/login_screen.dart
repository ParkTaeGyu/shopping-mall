import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Supabase requires email format
      final email = _emailController.text.trim();
      final success = await ref.read(authControllerProvider.notifier).login(
            email: email,
            password: _passwordController.text,
          );
      if (mounted) {
        setState(() => _isLoading = false);
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인 실패. 이메일 형식과 비밀번호를 확인해주세요.')),
          );
        }
      }
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final email = _emailController.text.trim();
      if (!email.contains('@')) {
         setState(() => _isLoading = false);
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('회원가입은 이메일 형식이 필요합니다.')),
          );
          return;
      }
      
      final success = await ref.read(authControllerProvider.notifier).signUp(
            email: email,
            password: _passwordController.text,
          );
      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('회원가입 완료. 로그인해주세요.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('회원가입 실패. 이미 사용 중인 이메일일 수 있어요.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: '이메일'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '이메일을 입력해주세요';
                    if (!value.contains('@')) return '유효한 이메일을 입력해주세요';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: '비밀번호'),
                  obscureText: true,
                  validator: (value) =>
                      value == null || value.isEmpty ? '비밀번호를 입력해주세요' : null,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('로그인'),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: _signUp,
                      child: const Text('회원가입'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
