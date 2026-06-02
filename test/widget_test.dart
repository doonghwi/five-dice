import 'package:flutter_test/flutter_test.dart';
import 'package:five_dice/game_state.dart';

void main() {
  test('roll always yields 5 dice in range 1..6', () {
    final s = GameState(playerCount: 3);
    for (int i = 0; i < 100; i++) {
      final dice = s.roll();
      expect(dice.length, 5);
      for (final v in dice) {
        expect(v, inInclusiveRange(1, 6));
      }
    }
  });

  test('full pass-and-play flow tallies all n*5 dice correctly', () {
    const n = 4;
    final s = GameState(playerCount: n);
    for (int p = 0; p < n; p++) {
      expect(s.phase, Phase.beforeRoll);
      s.roll();
      expect(s.phase, Phase.revealed);
      s.hideAndAdvance();
    }
    expect(s.phase, Phase.hidden);
    expect(s.allRolled, true);
    expect(s.totalDice, n * 5);

    final counts = s.tally();
    expect(counts.length, 6);
    expect(counts.fold<int>(0, (a, b) => a + b), n * 5);
  });

  test('tally matches a known fixed set of rolls', () {
    final s = GameState(playerCount: 2);
    s.currentDice = [1, 1, 2, 3, 6];
    s.hideAndAdvance();
    s.currentDice = [6, 6, 4, 5, 1];
    s.hideAndAdvance();
    // faces: 1->3, 2->1, 3->1, 4->1, 5->1, 6->3
    expect(s.tally(), [3, 1, 1, 1, 1, 3]);
  });
}
