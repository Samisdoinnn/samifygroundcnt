import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/firebase_config.dart';
import 'config/routes.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(const ProviderScope(child: GameVerseApp()));
}

class GameVerseApp extends ConsumerWidget {
  const GameVerseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return MaterialApp(
      title: 'GameVerse',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
      ),
      home: isAuthenticated ? const HomeScreen() : const LoginScreen(),
      routes: appRoutes,
    );
  }
}


