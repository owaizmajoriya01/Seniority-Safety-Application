class Pair<F, L> {
  final F first;
  final L last;

  Pair(this.first, this.last);

  @override
  String toString() {
    return 'Pair{first: $first, last: $last}';
  }
}