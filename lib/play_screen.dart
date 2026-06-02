import 'package:flutter/material.dart';
import 'theme.dart';
import 'dice_widget.dart';
import 'game_state.dart';
import 'result_screen.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key, required this.state});
  final GameState state;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  GameState get s => widget.state;
  bool _rolling = false;

  Future<void> _roll() async {
    setState(() => _rolling = true);
    await Future.delayed(const Duration(milliseconds: 850));
    if (!mounted) return;
    setState(() {
      s.roll();
      _rolling = false;
    });
  }

  void _hide() {
    setState(() => s.hideAndAdvance());
  }

  void _showResult() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResultScreen(state: s)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kFeltGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                _header(),
                Expanded(child: Center(child: _body())),
                _actions(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '진행  ${s.rolls.length} / ${s.playerCount}',
          style: TextStyle(
            color: AppColors.ivory.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: List.generate(s.playerCount, (i) {
            final done = i < s.rolls.length;
            final current = i == s.currentPlayer && s.phase != Phase.hidden;
            return Container(
              margin: const EdgeInsets.only(left: 6),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? AppColors.brass
                    : current
                        ? AppColors.ivory
                        : Colors.white24,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _body() {
    switch (s.phase) {
      case Phase.beforeRoll:
        return _turnCard(
          title: '${s.currentPlayer + 1}번 플레이어 차례',
          subtitle: '다른 사람이 보지 않을 때\n주사위를 굴리세요',
          icon: Icons.casino_outlined,
        );
      case Phase.revealed:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${s.currentPlayer + 1}번 플레이어',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.brass,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '확인했으면 "가리기"를 눌러 넘기세요',
              style: TextStyle(color: AppColors.ivory.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 28),
            DiceTray(values: s.currentDice, rolling: false, dieSize: 58),
          ],
        );
      case Phase.hidden:
        return _turnCard(
          title: '모든 플레이어 완료!',
          subtitle: '아래 버튼으로 전체 집계를\n확인하세요',
          icon: Icons.lock_outline,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _turnCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_rolling)
          DiceTray(values: s.currentDice, rolling: true, dieSize: 58)
        else
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 64, color: AppColors.brass),
          ),
        const SizedBox(height: 28),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.4,
            color: AppColors.ivory.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _actions() {
    switch (s.phase) {
      case Phase.beforeRoll:
        return _bigButton(
          label: _rolling ? '굴리는 중...' : '주사위 굴리기',
          icon: Icons.casino,
          color: AppColors.brass,
          onTap: _rolling ? null : _roll,
        );
      case Phase.revealed:
        return _bigButton(
          label: '가리기 (다음 사람에게)',
          icon: Icons.visibility_off,
          color: AppColors.danger,
          onTap: _hide,
        );
      case Phase.hidden:
        return _bigButton(
          label: '결과 확인',
          icon: Icons.bar_chart,
          color: AppColors.brass,
          onTap: _showResult,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _bigButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.feltBottom,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
