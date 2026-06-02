import 'package:flutter/material.dart';
import 'theme.dart';
import 'dice_widget.dart';
import 'game_state.dart';
import 'setup_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.state});
  final GameState state;

  @override
  Widget build(BuildContext context) {
    final counts = state.tally();
    final maxCount = counts.fold<int>(1, (m, c) => c > m ? c : m);
    final topCount = counts.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kFeltGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text(
                  '전체 집계 결과',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  '${state.playerCount}명 · 주사위 ${state.totalDice}개',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.ivory.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: 6,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _FaceRow(
                      face: i + 1,
                      count: counts[i],
                      maxCount: maxCount,
                      isTop: counts[i] == topCount && topCount > 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SetupScreen()),
                        (r) => false,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      '새 게임',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.brass,
                      foregroundColor: AppColors.feltBottom,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FaceRow extends StatelessWidget {
  const _FaceRow({
    required this.face,
    required this.count,
    required this.maxCount,
    required this.isTop,
  });

  final int face;
  final int count;
  final int maxCount;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.faceColors[face - 1];
    final fraction = maxCount == 0 ? 0.0 : count / maxCount;
    return Row(
      children: [
        Die(value: face, size: 46, accent: color),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, c) {
                  return Stack(
                    children: [
                      Container(
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        height: 26,
                        width: (c.maxWidth * fraction).clamp(0.0, c.maxWidth),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color.withValues(alpha: 0.6), color],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        SizedBox(
          width: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isTop ? AppColors.brass : AppColors.ivory,
                ),
              ),
              Text(
                '개',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.ivory.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
