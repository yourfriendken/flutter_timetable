import 'dart:math';
import 'package:flutter/material.dart';

/// A controller for the timetable.
///
/// The controller allow intialization of the timetable and to expose timetable functionality to the outside.
class TimetableController {
  TimetableController({
    /// The number of day columns to show.
    int initialColumns = 3,

    /// The start date (first column) of the timetable. Default is today.
    DateTime? start,

    /// The height of each cell in the timetable. Default is 50.
    double? cellHeight,

    /// The height of the header in the timetable. Default is 50.
    double? headerHeight,

    /// The width of the timeline where hour labels are rendered. Default is 50.
    double? timelineWidth,
  }) {
    _columns = initialColumns;
    _start = DateUtils.dateOnly(start ?? DateTime.now());
    _cellHeight = cellHeight ?? 50;
    _headerHeight = headerHeight ?? 50;
    _timelineWidth = timelineWidth ?? 50;
    _visibleDateStart = _start;
  }

  late DateTime _start;

  /// The [start] date (first column) of the timetable.
  DateTime get start => _start;
  set start(DateTime value) {
    _start = DateUtils.dateOnly(value);
    dispatch(TimetableStartChanged(_start));
  }

  int _columns = 3;

  /// The current number of [columns] in the timetable.
  int get columns => _columns;

  double _cellHeight = 50.0;

  /// The current height of each cell in the timetable.
  double get cellHeight => _cellHeight;

  final Map<int, Function(TimetableControllerEvent)> _listeners = {};

  double _headerHeight = 50.0;

  /// The current height of the header in the timetable.
  double get headerHeight => _headerHeight;

  double _timelineWidth = 50.0;

  /// The current width of the timeline where hour labels are rendered.
  double get timelineWidth => _timelineWidth;

  late DateTime _visibleDateStart;

  /// The first date of the visible area of the timetable.
  DateTime get visibleDateStart => _visibleDateStart;

  /// Allows listening to events dispatched from the timetable
  int addListener(Function(TimetableControllerEvent)? listener) {
    if (listener == null) return -1;
    final id = _listeners.isEmpty ? 0 : _listeners.keys.reduce(max) + 1;
    _listeners[id] = listener;
    return id;
  }

  /// Removes a listener from the timetable
  void removeListener(int id) => _listeners.remove(id);

  /// Removes all listeners from the timetable
  void clearListeners() => _listeners.clear();

  /// Dispatches an event to all listeners
  void dispatch(TimetableControllerEvent event) {
    for (var listener in _listeners.values) {
      listener(event);
    }
  }

  /// Scrolls the timetable to the given date and time.
  void jumpTo(DateTime date) {
    dispatch(TimetableJumpToRequested(date));
  }

  /// Updates the number of columns in the timetable
  setColumns(int i) {
    if (i == _columns) return;
    _columns = i;
    dispatch(TimetableColumnsChanged(i));
  }

  /// Updates the height of each cell in the timetable
  setCellHeight(double height) {
    if (height == _cellHeight) return;
    if (height <= 0) return;
    _cellHeight = min(height, 1000);
    dispatch(TimetableCellHeightChanged(height));
  }

  /// This allows the timetable to update the current visible date.
  void updateVisibleDate(DateTime date) {
    _visibleDateStart = date;
  }
}

/// A generic event that can be dispatched from the timetable controller
abstract class TimetableControllerEvent {}

/// Event used to change the cell height of the timetable
class TimetableCellHeightChanged extends TimetableControllerEvent {
  final double height;
  TimetableCellHeightChanged(this.height);
}

/// Event used to change the number of columns in the timetable
class TimetableColumnsChanged extends TimetableControllerEvent {
  TimetableColumnsChanged(this.columns);
  final int columns;
}

/// Event used to scroll the timetable to a given date and time
class TimetableJumpToRequested extends TimetableControllerEvent {
  TimetableJumpToRequested(this.date);
  final DateTime date;
}

/// Event dispatched when the start date of the timetable changes
class TimetableStartChanged extends TimetableControllerEvent {
  TimetableStartChanged(DateTime start);
}
