import 'package:flutter_test/flutter_test.dart';
import 'package:time_app/src/models/record.dart';

void main() {
  test('Test Record.sortByPriority', () {
    const fromA = '09:00 AM';
    const toA = '12:00 PM';
    final recordA = Record(
      titleArr: ['Meeting', 'with', 'Team'],
      date: DateTime.now(),
      from: fromA,
      to: toA,
      priority: Record.assignPriority(fromA, toA), //high
    );

    const fromB = '09:00 AM';
    const toB = '10:30 AM';
    final recordB = Record(
      titleArr: ['Another', 'Meeting'],
      date: DateTime.now(),
      from: fromB,
      to: toB,
      priority: Record.assignPriority(fromB, toB), //mid
    );

    const fromC = '09:00 AM';
    const toC = '09:45 AM';
    final recordC = Record(
      titleArr: ['Quick', 'Discussion'], //low
      date: DateTime.now(),
      from: fromC,
      to: toC,
      priority: Record.assignPriority(fromC, toC),
    );

    const fromD = '09:00 AM';
    const toD = '09:15 AM';
    final recordD = Record(
      titleArr: ['No', 'Priority', 'Set'],
      date: DateTime.now(),
      from: fromD,
      to: toD,
      priority: Record.assignPriority(fromD, toD), //low
    );

    final unsortedRecords = [
      recordB,
      recordC,
      recordD,
      recordA,
    ];
    final sortedRecords = Record.sortByPriority(unsortedRecords);

    expect(sortedRecords, equals([recordA, recordB, recordC, recordD]));
  });

  test('Test Record.assignPriority', () {
    expect(Record.assignPriority('09:00 AM', '05:30 PM'), equals('high'));
    expect(Record.assignPriority('05:30 PM', '09:00 AM'), equals('high'));

    expect(Record.assignPriority('09:00 AM', '12:30 PM'), equals('mid'));
    expect(Record.assignPriority('12:30 PM', '09:00 AM'), equals('mid'));

    expect(Record.assignPriority('09:00 AM', '09:45 AM'), equals('low'));
    expect(Record.assignPriority('09:45 AM', '09:00 AM'), equals('low'));
  });
}
