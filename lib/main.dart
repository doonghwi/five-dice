import 'package:flutter/material.dart';
import 'theme.dart';
import 'setup_screen.dart';

void main() => runApp(const FiveDiceApp());

class FiveDiceApp extends StatelessWidget {
  const FiveDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '주사위 5개 집계',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SetupScreen(),
    );
  }
}
