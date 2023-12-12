import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeService {
  static Random random = Random();

  static String dateToStr_ux(DateTime dateTime) {
    //used for frontEnd date display
    return DateFormat('EEE, M/d/yyyy').format(dateTime);
  }

  static DateTime? dateParser(String dateString) {
    List<String> parts = dateString.contains('-')
        ? dateString.split('-')
        : dateString.split('/');

    if (parts.length != 3) {
      return null;
    }

    int year = int.parse(parts[2]);
    int month = int.parse(parts[0]);
    int day = int.parse(parts[1]);
    print("PARSING::::: ${DateTime(year, month, day)}");
    return DateTime(year, month, day);
  }

  static String standardDate(DateTime dateTime) {
    //used for backend during fetchByDate
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  static String timeOfDayToString(TimeOfDay time) {
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    int hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    String minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute $period';
  }

  static bool isValidTimeFormat(String time) {
    // print('Regex-time-timeservice: $time');
    RegExp regex = RegExp(r'^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(?:AM|PM|am|pm)$');
    return regex.hasMatch(time);
  }

  //all methods below are only used for seeding DB
  static DateTime getRandomDate() {
    int randomYear = 2023;
    // int randomMonth = random.nextInt(12) + 1;
    int randomMonth = 12;
    int randomDay = random.nextInt(28) + 1;

    int randomHour = random.nextInt(24);
    int randomMinute = random.nextInt(60);
    int randomSecond = random.nextInt(60);
    int randomMillisecond = random.nextInt(1000);

    return DateTime(
      randomYear,
      randomMonth,
      randomDay,
      randomHour,
      randomMinute,
      randomSecond,
      randomMillisecond,
    );
  }

  static TimeOfDay getRandomTime() {
    int randomHour = random.nextInt(12) + 1;
    int randomMinute = random.nextInt(60);
    print(
        "getRandomTime: ${timeOfDayToString(TimeOfDay(hour: randomHour, minute: randomMinute))}");

    return TimeOfDay(hour: randomHour, minute: randomMinute);
  }

  static addRandomDuration(TimeOfDay time) {
    int randomHourDuration =
        time.hour >= 8 ? 12 - time.hour : random.nextInt(4) + 1;
    DateTime dateTime = DateTime(2023, 1, 1, time.hour, time.minute);
    dateTime = dateTime.add(Duration(hours: randomHourDuration));
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
}
