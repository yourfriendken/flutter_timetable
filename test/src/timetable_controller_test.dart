import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timetable/flutter_timetable.dart';

void main() {
  test("TimetableController", () {
    final controller = TimetableController();
    expect(controller, isNotNull);
  });

  test("TimetableController.start", () {
    dynamic event;
    final controller = TimetableController();
    controller.addListener((e) => event = e);
    controller.start = DateTime.now();
    expect(controller.start, isNotNull);
    expect(event, isA<TimetableStartChanged>());
    expect(event.start, isNotNull);
    expect(event.start, controller.start);
  });

  test("TimetableController.columns", () {
    dynamic event;
    final controller = TimetableController();
    controller.addListener((e) => event = e);
    controller.setColumns(7);
    expect(controller.columns, isNotNull);
    expect(controller.columns, 7);
    expect(event, isA<TimetableColumnsChanged>());
    expect(event.columns, isNotNull);
    expect(event.columns, controller.columns);
  });

  test("TimetableController.cellHeight", () {
    dynamic event;
    final controller = TimetableController();
    controller.addListener((e) => event = e);
    controller.setCellHeight(55);
    expect(controller.cellHeight, isNotNull);
    expect(controller.cellHeight, 55);
    expect(event, isA<TimetableCellHeightChanged>());
    expect(event.height, isNotNull);
    expect(event.height, controller.cellHeight);
  });

  test("TimetableController.jumpTo", () {
    dynamic event;
    final date = DateTime(2020, 1, 1);
    final controller = TimetableController();
    controller.addListener((e) => event = e);
    controller.jumpTo(date);
    expect(event, isA<TimetableJumpToRequested>());
    expect(event.date, isNotNull);
    expect(event.date, date);
  });

  test("TimetableController.updateVisibleDate", () {
    final date = DateTime(2020, 1, 1);
    final controller = TimetableController();
    controller.updateVisibleDate(date);
    expect(controller.visibleDateStart, date);
  });

  test("TimetableController.dispatch", () {
    final controller = TimetableController();
    dynamic event;
    controller.addListener((e) => event = e);
    controller.dispatch(TimetableJumpToRequested(DateTime(2020, 1, 1)));
    expect(event, isA<TimetableJumpToRequested>());
  });

  test("TimetableController.removeListener", () {
    final controller = TimetableController();
    final id = controller.addListener((e) {});
    expect(controller.hasListeners, isTrue);
    controller.removeListener(id);
    expect(controller.hasListeners, isFalse);
  });

  test("TimetableController.clearListeners", () {
    final controller = TimetableController();
    controller.addListener((e) {});
    expect(controller.hasListeners, isTrue);
    controller.clearListeners();
    expect(controller.hasListeners, isFalse);
  });

  test("TimetableController.addListener null", () {
    final controller = TimetableController();
    controller.addListener(null);
    expect(controller.hasListeners, isFalse);
  });
}
