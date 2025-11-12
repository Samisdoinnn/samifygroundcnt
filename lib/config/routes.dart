import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/create_post_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/leaderboard/leaderboard_screen.dart';
import '../screens/profile/edit_profile_screen.dart';

class Routes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String createPost = '/create_post';
  static const String editProfile = '/edit_profile';
  static const String leaderboard = '/leaderboard';
}

final Map<String, WidgetBuilder> appRoutes = {
  Routes.login: (_) => const LoginScreen(),
  Routes.register: (_) => const RegisterScreen(),
  Routes.home: (_) => const HomeScreen(),
  Routes.createPost: (_) => const CreatePostScreen(),
  Routes.editProfile: (_) => const EditProfileScreen(),
  Routes.leaderboard: (_) => const LeaderboardScreen(),
};


