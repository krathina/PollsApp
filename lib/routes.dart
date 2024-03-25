import 'package:flutter/material.dart';
import 'package:polls_app/screens/home/home_screen.dart';
import 'package:polls_app/screens/login/login_screen.dart';
import 'package:polls_app/screens/register/register_screen.dart';

final routes = {
  '/login': (BuildContext context) => const LoginScreen(),
  '/register': (BuildContext context) => const RegisterScreen(),
  '/home': (BuildContext context) => const HomeScreen(),
  '/': (BuildContext context) => const LoginScreen(),
};
