extension ListDuplicates<E> on List<E> {
  List<E> removeAll(Iterable<E> itemsToRemove) {
    for (var e in itemsToRemove) {
      remove(e);
      // will remove the items at first occurance
    }
    return this;
  }

  List<E> get duplicates {
    List<E> copy = List.from(this);
    copy.removeAll(toSet());
    return copy;
  }
}
