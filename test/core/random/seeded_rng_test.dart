import 'package:bogcc_demo_mobile_app/core/random/mulberry32.dart';
import 'package:bogcc_demo_mobile_app/core/random/seeded_rng.dart';
import 'package:flutter_test/flutter_test.dart';

/// The frozen values below are the actual output of the web demo's
/// `src/lib/random.ts` running under Node, captured once and pasted here.
///
/// They are not illustrative and must not be regenerated from the Dart side. A
/// 32-bit masking slip in the port still yields a perfectly deterministic
/// stream — just a different one — so "two Dart runs agree" proves nothing.
/// Only these literals prove the two codebases seed the same demo.
const _seed = 'bogcc-2026-09-26';

const _expectedSeedFrom = 1188679197;

const _expectedFirst10 = <double>[
  0.23238617787137628,
  0.472228359663859,
  0.5944611697923392,
  0.49154356122016907,
  0.510690936120227,
  0.13349189143627882,
  0.38237215485423803,
  0.045575196389108896,
  0.46311432030051947,
  0.7388720249291509,
];

void main() {
  group('mulberry32', () {
    test('seedFrom matches the JavaScript FNV-1a', () {
      expect(seedFrom(_seed), _expectedSeedFrom);
      expect(seedFrom('2026-09-25'), 2412934129);
    });

    test('produces the same stream as the web demo', () {
      final rng = makeRng(seedFrom(_seed));
      for (var i = 0; i < _expectedFirst10.length; i++) {
        expect(rng(), _expectedFirst10[i], reason: 'draw $i diverged');
      }
    });

    test('a zero seed still advances, rather than sticking', () {
      // Guards the `a = (a + 0x6D2B79F5)` step: if the mask were applied in the
      // wrong place, seed 0 is where it would show up first.
      final rng = makeRng(0);
      expect(rng(), closeTo(0.26642920868471265, 1e-15));
    });

    test('every draw is in [0, 1)', () {
      final rng = makeRng(seedFrom('range-check'));
      for (var i = 0; i < 10000; i++) {
        final v = rng();
        expect(v, greaterThanOrEqualTo(0.0));
        expect(v, lessThan(1.0));
      }
    });
  });

  group('SeededRng', () {
    test('int_ draws the same sequence as the web demo', () {
      final r = SeededRng(_seed);
      expect(
        List.generate(8, (_) => r.int_(1, 21)),
        [5, 10, 13, 11, 11, 3, 9, 1],
      );
    });

    test('chance draws the same sequence as the web demo', () {
      final r = SeededRng(_seed);
      expect(
        List.generate(8, (_) => r.chance(0.4)),
        [true, false, false, false, false, true, true, true],
      );
    });

    test('shuffle matches the web demo, not merely itself', () {
      final r = SeededRng(_seed);
      expect(
        r.shuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
        [6, 10, 8, 2, 1, 7, 4, 9, 5, 3],
      );
    });

    test('pick draws the same sequence as the web demo', () {
      final r = SeededRng(_seed);
      expect(
        List.generate(5, (_) => r.pick(['ক', 'খ', 'গ', 'ঘ'])),
        ['ক', 'খ', 'গ', 'খ', 'গ'],
      );
    });

    test('shuffle leaves the input alone', () {
      final r = SeededRng(_seed);
      final input = [1, 2, 3, 4, 5];
      r.shuffle(input);
      expect(input, [1, 2, 3, 4, 5]);
    });

    test('int_ stays in range at the bounds', () {
      final r = SeededRng('bounds');
      for (var i = 0; i < 5000; i++) {
        final v = r.int_(1, 21);
        expect(v, inInclusiveRange(1, 21));
      }
      expect(r.int_(7, 7), 7);
    });

    test('the same seed replays exactly', () {
      final a = SeededRng(_seed);
      final b = SeededRng(_seed);
      expect(
        List.generate(50, (_) => a.next()),
        List.generate(50, (_) => b.next()),
      );
    });
  });
}
