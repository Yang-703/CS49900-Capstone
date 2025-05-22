/* test/leaderboard_test.dart */
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_study_app/views/leaderboard.dart';

void main() {
  final lb = Leaderboard();

  group('Leaderboard.getShortName', () {
    test('returns full name if ≤7 chars', () {
      expect(lb.getShortName('Alice'), 'Alice');
      expect(lb.getShortName('Bob1234'), 'Bob1234');
    });

    test('truncates to first 7 chars if longer', () {
      expect(lb.getShortName('Christopher'), 'Christo');
      expect(lb.getShortName('LeaderboardUser'), 'Leaderb');
    });
  });
}