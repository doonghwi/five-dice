import 'package:flutter/material.dart';
import 'theme.dart';
import 'dice_widget.dart';
import 'game_state.dart';
import 'play_screen.dart';

/// Entry screen: choose the number of players, then start.
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _players = 3;
  static const _min = 2;
  static const _max = 12;

  void _start() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayScreen(state: GameState(playerCount: _players)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kFeltGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Wrap(
                    spacing: 10,
                    children: [
                      Die(value: 5, size: 52),
                      Die(value: 2, size: 52),
                      Die(value: 6, size: 52),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    '주사위 5개 집계',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '한 기기를 돌려가며 즐기는 패스앤플레이',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.ivory.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    '참가 인원',
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 1,
                      color: AppColors.brass,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StepButton(
                        icon: Icons.remove,
                        onTap: _players > _min
                            ? () => setState(() => _players--)
                            : null,
                      ),
                      SizedBox(
                        width: 110,
                        child: Text(
                          '$_players',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _StepButton(
                        icon: Icons.add,
                        onTap: _players < _max
                            ? () => setState(() => _players++)
                            : null,
                      ),
                    ],
                  ),
                  Text(
                    '명  ·  $_min ~ $_max',
                    style: TextStyle(
                      color: AppColors.ivory.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 44),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _start,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.brass,
                        foregroundColor: AppColors.feltBottom,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        '게임 시작',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: enabled
          ? AppColors.brass.withValues(alpha: 0.18)
          : Colors.white.withValues(alpha: 0.05),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(
            icon,
            size: 28,
            color: enabled ? AppColors.brass : Colors.white24,
          ),
        ),
      ),
    );
  }
}
