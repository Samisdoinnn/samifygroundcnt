import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final authService = ref.read(authServiceProvider);
    final user = await authService.loginWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (user != null) {
      ref.read(currentUserDataProvider.notifier).setCurrentUser(user);
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);
    final authService = ref.read(authServiceProvider);
    final user = await authService.signInWithGoogle();
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (user != null) {
      ref.read(currentUserDataProvider.notifier).setCurrentUser(user);
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google sign-in cancelled.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Text(
                '🎮 GameVerse',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _isLoading ? null : _googleSignIn,
                child: const Text('Sign in with Google'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.register);
                },
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


