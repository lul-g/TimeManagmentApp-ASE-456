import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_app/src/services/TimeService.dart';

void main() {
  group('TimeService Tests', () {
    test('dateToStr_ux should format DateTime to a user-friendly string', () {
      DateTime dateTime = DateTime(2023, 12, 31);
      expect(TimeService.dateToStr_ux(dateTime), 'Sun, 12/31/2023');
    });

    test('dateToString should parse a date string to DateTime', () {
      String dateString = '12-31-2023';
      DateTime? result = TimeService.dateParser(dateString);
      expect(result, DateTime(2023, 12, 31));
    });

    test('standardDate should format DateTime to a standard date string', () {
      DateTime dateTime = DateTime(2023, 12, 31);
      expect(TimeService.standardDate(dateTime), '12/31/2023');
    });

    test('timeOfDayToString should format TimeOfDay to a string', () {
      TimeOfDay time = const TimeOfDay(hour: 10, minute: 30);
      expect(TimeService.timeOfDayToString(time), '10:30 AM');
    });

    test('isValidTimeFormat should check if a time string has a valid format',
        () {
      expect(TimeService.isValidTimeFormat('12:30 PM'), true);
      expect(TimeService.isValidTimeFormat('14:30'), false);
    });
  });
}
