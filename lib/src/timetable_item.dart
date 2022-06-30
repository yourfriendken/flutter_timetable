/// A time table item is a single entry in a time table.
/// Required fields:
///  - [start] - DateTime the start time of the item
///  - [end] - DateTime the end time of the item
///
/// Optional fields:
///  - [data] - Optional generic payload that can be used by the item builder to render the item card
///
/// Caluculated fields:
/// - [duration] - Duration is the difference between [start] and [end] provided in the constructor
class TimetableItem<T> {
  TimetableItem(this.start, this.end, {this.data})
      : assert(start.isBefore(end)),
        duration = end.difference(start);
  final DateTime start;
  final DateTime end;
  final T? data;
  final Duration duration;
}
