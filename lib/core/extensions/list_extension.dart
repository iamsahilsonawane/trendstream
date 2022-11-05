extension ListExtensions<E> on List<E> {
  List<E> removeAll(Iterable<E>? allToRemove) {
    if (allToRemove == null) {
      return this;
    } else {
      for (var element in allToRemove) {
        remove(element);
      }
      return this;
    }
  }

  List<E> get duplicates {
    List<E> dupes = List.from(this);
    dupes.removeAll(toSet().toList());
    return dupes;
  }
}
