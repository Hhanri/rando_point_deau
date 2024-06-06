extension ListUtils<I> on List<I> {
  List<O> mapList<O>(O Function(I element) transform) {
    return List.generate(length, (index) => transform(this[index]));
  }
}
