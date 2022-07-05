import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timetable/flutter_timetable.dart';

void main() {
  test('TimetableItem', () {
    const data = "test";
    final item =
        TimetableItem(DateTime(2020, 1, 1), DateTime(2020, 1, 2), data: data);
    expect(item.start, DateTime(2020, 1, 1));
    expect(item.end, DateTime(2020, 1, 2));
    expect(item.duration, const Duration(days: 1));
    expect(item.data, isA<String>());
    expect(item.data, data);
  });
}
