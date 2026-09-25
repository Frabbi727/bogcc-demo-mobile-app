import 'mulberry32.dart';

/// A seeded source of the small choices the demo data is made of.
///
/// Every draw must happen in the same order on every device, so nothing here is
/// async and nothing caches: the seed builder's call order *is* the contract.
class SeededRng {
  SeededRng(Object seed)
      : _next = makeRng(seed is String ? seedFrom(seed) : seed as int);

  final double Function() _next;

  /// Float in [0, 1).
  double next() => _next();

  /// Integer in [min, max], inclusive.
  int int_(int min, int max) => min + (next() * (max - min + 1)).floor();

  /// One element of a non-empty list.
  T pick<T>(List<T> items) => items[int_(0, items.length - 1)];

  /// True with the given probability.
  bool chance(double probability) => next() < probability;

  /// A shuffled copy, Fisher-Yates, drawing in the same order as the original.
  List<T> shuffle<T>(List<T> items) {
    final out = List<T>.of(items);
    for (var i = out.length - 1; i > 0; i--) {
      final j = int_(0, i);
      final tmp = out[i];
      out[i] = out[j];
      out[j] = tmp;
    }
    return out;
  }
}
