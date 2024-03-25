import 'package:flutter/material.dart';
import 'package:polls_app/routes.dart';

void main() => runApp(const PollsApp());

class PollsApp extends StatelessWidget {
  const PollsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polls',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: routes,
    );
  }
}
