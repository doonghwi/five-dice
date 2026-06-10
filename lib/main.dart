import 'package:flutter/material.dart';
import 'dailyapp_stats.dart';
import 'theme.dart';
import 'setup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DailyAppStats.recordOpen(
    appId: 'five_dice',
    name: '🎲 주사위 집계',
    desc: '패스앤플레이 · 5주사위 모아 1~6 눈 개수 집계',
    platforms: ['web', 'android', 'offline'],
    webUrl: 'https://doonghwi.github.io/five-dice/',
    repoUrl: 'https://github.com/doonghwi/five-dice',
    day: 'Day 2',
  );
  runApp(const FiveDiceApp());
}

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
