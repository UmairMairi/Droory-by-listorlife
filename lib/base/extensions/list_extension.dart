
extension ListExtension<E> on List<E> {
  /// Add [item] to [List<E>] only if [item] is not null.
  void addNonNull(E item) {
    if (item != null) add(item);
  }

  /// Add [item] to List<E> only if [condition] is true.
  void addIf(dynamic condition, E item) {
    if (condition is bool && condition) {
      add(item);
    }
  }

  /// Adds [Iterable<E>] to [List<E>] only if [condition] is true.
  void addAllIf(dynamic condition, Iterable<E> items) {
    if (condition is bool && condition) {
      addAll(items);
    }
  }
}
