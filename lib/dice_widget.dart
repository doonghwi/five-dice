import 'package:flutter/material.dart';
import 'theme.dart';

/// A single die rendered with custom-painted pips (no fonts/emoji needed).
class Die extends StatelessWidget {
  const Die({super.key, required this.value, this.size = 64, this.accent});

  final int value; // 1..6
  final double size;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.ivory, AppColors.ivoryShadow],
        ),
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: size * 0.12,
            offset: Offset(0, size * 0.08),
          ),
        ],
        border: Border.all(
          color: (accent ?? AppColors.brass).withValues(alpha: 0.55),
          width: 1.5,
        ),
      ),
      child: CustomPaint(painter: _PipPainter(value)),
    );
  }
}

class _PipPainter extends CustomPainter {
  _PipPainter(this.value);
  final int value;

  // Pip layout grid positions (col, row) in a 3x3 grid, normalized.
  static const _g = [0.26, 0.5, 0.74];

  static const Map<int, List<List<int>>> _layouts = {
    1: [[1, 1]],
    2: [[0, 0], [2, 2]],
    3: [[0, 0], [1, 1], [2, 2]],
    4: [[0, 0], [2, 0], [0, 2], [2, 2]],
    5: [[0, 0], [2, 0], [1, 1], [0, 2], [2, 2]],
    6: [[0, 0], [2, 0], [0, 1], [2, 1], [0, 2], [2, 2]],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.pip..isAntiAlias = true;
    final r = size.width * 0.085;
    for (final pos in _layouts[value] ?? const []) {
      final dx = _g[pos[0]] * size.width;
      final dy = _g[pos[1]] * size.height;
      canvas.drawCircle(Offset(dx, dy), r, paint);
    }
  }

  @override
  bool shouldRepaint(_PipPainter old) => old.value != value;
}

/// A row of five dice that shuffles values while [rolling], then settles.
class DiceTray extends StatefulWidget {
  const DiceTray({
    super.key,
    required this.values,
    required this.rolling,
    this.dieSize = 60,
  });

  final List<int> values;
  final bool rolling;
  final double dieSize;

  @override
  State<DiceTray> createState() => _DiceTrayState();
}

class _DiceTrayState extends State<DiceTray>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late List<int> _shown;
  int _seed = 7;

  @override
  void initState() {
    super.initState();
    _shown = List.of(widget.values);
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    )..addListener(_tick);
    if (widget.rolling) _startRolling();
  }

  void _startRolling() {
    _ctrl.repeat();
  }

  void _tick() {
    // Cheap deterministic shuffle (no dart:math import needed here).
    setState(() {
      _shown = List.generate(5, (i) {
        _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
        return (_seed >> (i + 3)) % 6 + 1;
      });
    });
  }

  @override
  void didUpdateWidget(DiceTray old) {
    super.didUpdateWidget(old);
    if (widget.rolling && !old.rolling) {
      _startRolling();
    } else if (!widget.rolling && old.rolling) {
      _ctrl.stop();
      setState(() => _shown = List.of(widget.values));
    } else if (!widget.rolling && widget.values != old.values) {
      setState(() => _shown = List.of(widget.values));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        for (int i = 0; i < 5; i++)
          AnimatedScale(
            scale: widget.rolling ? 0.92 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Die(
              value: _shown.length > i ? _shown[i] : 1,
              size: widget.dieSize,
            ),
          ),
      ],
    );
  }
}
