import 'dart:math';
import 'package:flutter/material.dart';

class TimetableController {
  TimetableController({
    int initialColumns = 3,
    DateTime? start,
    double? cellHeight,
    double? headerHeight,
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
  DateTime get start => _start;

  int _columns = 3;
  int get columns => _columns;

  double _cellHeight = 50.0;
  double get cellHeight => _cellHeight;

  final Map<int, Function(TimetableControllerEvent)> _listeners = {};

  double _headerHeight = 50.0;
  double get headerHeight => _headerHeight;

  double _timelineWidth = 50.0;
  double get timelineWidth => _timelineWidth;

  late DateTime _visibleDateStart;
  DateTime get visibleDateStart => _visibleDateStart;

  int addListener(Function(TimetableControllerEvent)? listener) {
    if (listener == null) return -1;
    final id = _listeners.isEmpty ? 0 : _listeners.keys.reduce(max) + 1;
    _listeners[id] = listener;
    return id;
  }

  void removeListener(int id) => _listeners.remove(id);
  void clearListeners() => _listeners.clear();
  void dispatch(TimetableControllerEvent event) {
    for (var listener in _listeners.values) {
      listener(event);
    }
  }

  void jumpTo(DateTime date) {
    dispatch(TimetableJumpTo(date));
  }

  setColumns(int i) {
    if (i == _columns) return;
    _columns = i;
    dispatch(TimetableColumnsChanged(i));
  }

  setCellHeight(double height) {
    if (height == _cellHeight) return;
    if (height <= 0) return;
    _cellHeight = min(height, 1000);
    dispatch(TimetableCellHeightChanged(height));
  }

  void updateVisibleDate(DateTime date) {
    _visibleDateStart = date;
  }
}

abstract class TimetableControllerEvent {}

class TimetableCellHeightChanged extends TimetableControllerEvent {
  final double height;
  TimetableCellHeightChanged(this.height);
}

class TimetableColumnsChanged extends TimetableControllerEvent {
  TimetableColumnsChanged(this.columns);
  final int columns;
}

class TimetableJumpTo extends TimetableControllerEvent {
  TimetableJumpTo(this.date);
  final DateTime date;
}
