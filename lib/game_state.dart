import 'dart:math';

/// Per-game phases for the pass-and-play flow.
enum Phase { setup, beforeRoll, revealed, hidden, result }

class GameState {
  GameState({required this.playerCount}) : _rng = Random();

  final int playerCount;
  final Random _rng;

  /// Each entry is one player's five dice (1..6).
  final List<List<int>> rolls = [];

  int currentPlayer = 0; // 0-based
  Phase phase = Phase.beforeRoll;
  List<int> currentDice = const [1, 1, 1, 1, 1];

  bool get isLastPlayer => currentPlayer == playerCount - 1;
  bool get allRolled => rolls.length == playerCount;

  /// Roll five fresh dice for the current player.
  List<int> roll() {
    currentDice = List.generate(5, (_) => _rng.nextInt(6) + 1);
    phase = Phase.revealed;
    return currentDice;
  }

  /// Hide the current player's dice and advance.
  void hideAndAdvance() {
    rolls.add(List.of(currentDice));
    if (isLastPlayer) {
      phase = Phase.hidden; // ready for result
    } else {
      currentPlayer++;
      currentDice = const [1, 1, 1, 1, 1];
      phase = Phase.beforeRoll;
    }
  }

  /// Tally counts for faces 1..6 across all dice. Index 0 => face 1.
  List<int> tally() {
    final counts = List<int>.filled(6, 0);
    for (final hand in rolls) {
      for (final v in hand) {
        counts[v - 1]++;
      }
    }
    return counts;
  }

  int get totalDice => rolls.length * 5;
}
