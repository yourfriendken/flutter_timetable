import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timetable/flutter_timetable.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets("Timetable", (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Timetable(
          key: Key("TEST"),
        ),
      ),
    );
    expect(find.byType(Timetable), findsOneWidget);
    expect(find.byKey(const Key("TEST")), findsOneWidget);
  });
  testWidgets("Timetable sorts items", (WidgetTester tester) async {
    final items = [
      TimetableItem(
        DateTime(2020, 1, 1, 10, 0),
        DateTime(2020, 1, 1, 11, 0),
      ),
      TimetableItem(
        DateTime(2020, 1, 1, 9, 0),
        DateTime(2020, 1, 1, 10, 0),
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Timetable(items: items),
      ),
    );
    expect(items.first.start, DateTime(2020, 1, 1, 9, 0));
    expect(items.last.start, DateTime(2020, 1, 1, 10, 0));
  });

  testWidgets("Timetable with custom header cell", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Timetable(
          headerCellBuilder: (DateTime date) => Text(date.toString()),
        ),
      ),
    );
    final today = DateUtils.dateOnly(DateTime.now());
    expect(find.text(today.toString()), findsOneWidget);
  });

  testWidgets("Timetable with custom cell", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Timetable(
          cellBuilder: (DateTime date) => Text(date.toString()),
        ),
      ),
    );
    final today = DateUtils.dateOnly(DateTime.now());
    expect(find.text(today.toString()), findsOneWidget);
  });

  testWidgets("Timetable with custom hour label", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Timetable(
          hourLabelBuilder: (TimeOfDay time) => Text(time.toString()),
        ),
      ),
    );
    expect(find.text(const TimeOfDay(hour: 12, minute: 0).toString()),
        findsOneWidget);
  });

  testWidgets("Timetable with custom day label", (WidgetTester tester) async {
    final items = [
      TimetableItem<String>(
        DateTime(2020, 1, 1, 10, 0),
        DateTime(2020, 1, 1, 11, 0),
        data: "test",
      ),
      TimetableItem<String>(
        DateTime(2020, 1, 1, 9, 0),
        DateTime(2020, 1, 1, 10, 0),
        data: "test 2",
      ),
    ];
    final controller = TimetableController(
      start: DateTime(2020, 1, 1, 10, 0),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Timetable<String>(
          items: items,
          itemBuilder: (item) => Text(item.data ?? ""),
          controller: controller,
        ),
      ),
    );
    expect(find.text("test", skipOffstage: false), findsOneWidget);
    expect(find.text("test 2", skipOffstage: false), findsOneWidget);
  });

  testWidgets("Timetable with custom day label", (WidgetTester tester) async {
    final item = TimetableItem<String>(
      DateTime(2020, 1, 1, 10, 0),
      DateTime(2020, 1, 1, 11, 0),
      data: "test",
    );

    final controller = TimetableController(
      start: DateTime(2020, 1, 1, 10, 0),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Timetable<String>(
          items: [item],
          controller: controller,
        ),
      ),
    );
    final hmma = DateFormat("h:mm a");
    final label = "${hmma.format(item.start)} - ${hmma.format(item.end)}";
    expect(find.text(label, skipOffstage: false), findsOneWidget);
  });

  testWidgets("Timetable custom corner", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Timetable(
          cornerBuilder: (DateTime date) => Text("TEST"),
        ),
      ),
    );
    expect(find.text("TEST"), findsOneWidget);
  });

  testWidgets("controller jump to", (tester) async {
    final controller = TimetableController(
      start: DateTime(2020, 1, 1, 10, 0),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Timetable(
          controller: controller,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(controller.visibleDateStart, DateTime(2020, 1, 1));
    controller.jumpTo(DateTime(2020, 1, 15, 11));
    await tester.pumpAndSettle();
    expect(controller.visibleDateStart, DateTime(2020, 1, 15));
  });

  testWidgets("controller columns changed", (tester) async {
    final controller = TimetableController(
      start: DateTime(2020, 1, 1, 10, 0),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Timetable(
          controller: controller,
          headerCellBuilder: (_) => const Text("TEST"),
        ),
      ),
    );
    await tester.pumpAndSettle();
    controller.setColumns(2);
    await tester.pumpAndSettle();
    expect(find.text("TEST"), findsNWidgets(2));
  });

  testWidgets("controller columns changed", (tester) async {
    final controller = TimetableController(
      start: DateTime(2020, 1, 1),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Timetable(
          controller: controller,
          headerCellBuilder: (date) => Text(date.toString()),
        ),
      ),
    );

    // drag to the left
    await tester.drag(
        find.text(DateTime(2020, 1, 1).toString()), const Offset(-200, -200));
    await tester.pumpAndSettle();
    expect(find.text(DateTime(2020, 1, 4).toString()), findsOneWidget);
  });
}
