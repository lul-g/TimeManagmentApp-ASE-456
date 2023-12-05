import 'package:flutter/material.dart';
import 'package:time_app/src/utils/constants.dart';
import 'dart:math';

class Record {
  String? docId;
  String? title;
  DateTime? dateTime = DateTime.now();
  String? slot;
  Color? bgColor;
  List<String>? tags;

  Record({
    this.docId = '',
    this.title = '',
    this.dateTime,
    this.slot = '',
    this.bgColor,
    this.tags,
  }) {
    dateTime = dateTime ?? DateTime.now();
    bgColor = bgColor ?? Colors.grey.withOpacity(0.3);
  }

  static List<Record> generateMockRecords() {
    return [
      Record(
        title: 'Go dog walking',
        dateTime: DateTime.now(),
        slot: '9:00 - 10:00 am',
        bgColor: KThemeColors.red,
        tags: ['Study', 'Work', 'Home', 'Job'],
      ),
      Record(
        title: 'Go to gym',
        dateTime: DateTime.now().subtract(Duration(hours: 1)),
        slot: '10:00 - 11:00 am',
        bgColor: KThemeColors.yellow,
        tags: ['Study', 'Work', 'Home', 'Job'],
      ),
      Record(
        title: '',
        dateTime: getRandomDateTime(),
        slot: '',
        tags: [],
      ),
      Record(
        title: 'Study for finals',
        dateTime: getRandomDateTime(),
        slot: '12:00 - 1:00 pm',
        bgColor: KThemeColors.blue,
        tags: ['Study', 'Work', 'Home', 'Job'],
      ),
      Record(
        title: 'Study for finals',
        dateTime: DateTime.now().add(Duration(hours: 1)),
        slot: '12:00 - 1:00 pm',
        bgColor: KThemeColors.blue,
        tags: ['Study', 'Work', 'Home', 'Job'],
      ),
      Record(
        title: 'Study for finals',
        dateTime: DateTime.now().add(Duration(hours: 2)),
        slot: '12:00 - 1:00 pm',
        bgColor: KThemeColors.blue,
        tags: ['Study', 'Work', 'Home', 'Job'],
      ),
      Record(
        title: 'Study for finals',
        dateTime: getRandomDateTime(),
        slot: '12:00 - 1:00 pm',
        bgColor: KThemeColors.blue,
        tags: ['Study', 'Work', 'Home', 'Job'],
      ),
      Record(
          title: 'Study for finals',
          dateTime: DateTime.now().subtract(Duration(hours: 3)),
          slot: '12:00 - 1:00 pm',
          bgColor: KThemeColors.blue,
          tags: [
            'Fun',
            'Gym',
            'Gaming',
          ]),
      Record(
          title: 'Study for finals',
          dateTime: DateTime.now(),
          slot: '12:00 - 1:00 pm',
          bgColor: KThemeColors.red,
          tags: [
            'Fun',
          ]),
      Record(
          title: 'Study for finals',
          dateTime: DateTime.now().subtract(Duration(hours: 1)),
          slot: '12:00 - 1:00 pm',
          bgColor: KThemeColors.blue,
          tags: [
            'Gym',
          ]),
      Record(
          title: 'Study for finals',
          dateTime: DateTime.now().add(Duration(hours: 2)),
          slot: '12:00 - 1:00 pm',
          bgColor: KThemeColors.blue,
          tags: [
            'Gaming',
          ]),
      Record(
          title: 'Study for finals',
          dateTime: DateTime.now().subtract(Duration(hours: 2)),
          slot: '12:00 - 1:00 pm',
          bgColor: KThemeColors.blue,
          tags: [
            'Fun',
            'Gym',
            'Gaming',
          ]),
      Record(
          title: 'Study for finals',
          dateTime: DateTime.now().subtract(Duration(hours: 1)),
          slot: '12:00 - 1:00 pm',
          bgColor: KThemeColors.yellow,
          tags: [
            'Fun',
            'Gym',
            'Gaming',
          ]),
    ];
  }

  static DateTime getRandomDateTime() {
    Random random = Random();

    int randomYear = 2020;
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
}
