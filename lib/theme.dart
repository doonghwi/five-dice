import 'package:flutter/material.dart';

/// Casino-felt palette: deep emerald table, ivory dice, brass accents.
class AppColors {
  static const feltTop = Color(0xFF0E5B45);
  static const feltBottom = Color(0xFF063528);
  static const ivory = Color(0xFFF6F1E7);
  static const ivoryShadow = Color(0xFFD8CFBC);
  static const pip = Color(0xFF1A1A1A);
  static const brass = Color(0xFFE7B85C);
  static const brassDeep = Color(0xFFB8862F);
  static const danger = Color(0xFFE0654E);

  static const faceColors = <Color>[
    Color(0xFFE0654E), // 1
    Color(0xFFE8A24A), // 2
    Color(0xFFE7C84C), // 3
    Color(0xFF7BC47F), // 4
    Color(0xFF5AA9E6), // 5
    Color(0xFFB18BD9), // 6
  ];
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.brass,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.feltBottom,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.ivory,
      displayColor: AppColors.ivory,
    ),
  );
}

const kFeltGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [AppColors.feltTop, AppColors.feltBottom],
);
