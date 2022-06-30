class TimetableItem<T> {
  TimetableItem(this.start, this.end, {this.data})
      : assert(start.isBefore(end)),
        duration = end.difference(start);
  final DateTime start;
  final DateTime end;
  final T? data;
  final Duration duration;
}
