import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_app/src/services/TimeService.dart';

class Record {
  String? docId;
  List<String> titleArr;
  String? description;
  DateTime date;
  String from;
  String to;
  String? priority;
  List<String>? tags;

  Record({
    this.docId = '',
    this.description = '',
    required this.titleArr,
    required this.date,
    required this.from,
    required this.to,
    this.priority = '',
    this.tags,
  });

  static List<String> sampleTitles = [
    'Meeting with Team For a very long title',
    'Project Update',
    'Task Review',
    'Client Call',
    'Presentation Preparation',
    'Code Refactoring',
    'Release Planning',
    'Bug Fixing',
    'User Testing',
    'Documentation Update',
  ];

  static List<String> sampleDescriptions = [
    'Discuss project milestones and goals with the team.',
    'Provide updates on the current project status.',
    'Review and prioritize upcoming tasks.',
    'Discuss client requirements and project scope. It is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing'
        'Prepare slides for the upcoming presentation.',
    'Refactor existing code for better performance.',
    'Plan the release schedule for the next version.',
    'Fix bugs reported by the QA team. ',
    'Conduct user testing for new features.',
    'Update documentation for recent changes. It is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing',
  ];

  static List<String> samplePriorities = ['high', 'mid', 'low'];

  static List<List<String>> sampleTags = [
    ['meeting', 'team', 'planning', 'more', 'a lot', 'more', 'tags'],
    ['project', 'update', 'status'],
    ['task', 'review', 'priority'],
    ['client', 'call', 'requirements'],
    ['presentation', 'more', 'a lot', 'more', 'tags', 'preparation', 'slides'],
    ['code', 'refactoring', 'performance'],
    ['release', 'planning', 'schedule'],
    ['bug', 'fixing', 'qa'],
    ['user', 'testing', 'features'],
    ['documentation', 'update', 'changes'],
  ];

  static List<Record> generateMockRecords() {
    List<Record> records = [];

    for (int i = 0; i < 10; i++) {
      TimeOfDay randFrom = TimeService.getRandomTime();
      TimeOfDay randTo = TimeService.addRandomDuration(randFrom);

      Record record = Record(
        titleArr: sampleTitles[i].split(' '),
        description: sampleDescriptions[i % sampleDescriptions.length],
        date: TimeService.getRandomDate(),
        from: TimeService.timeOfDayToString(randFrom),
        to: TimeService.timeOfDayToString(randTo),
        priority: assignPriority(TimeService.timeOfDayToString(randFrom),
            TimeService.timeOfDayToString(randTo)),
        tags: sampleTags[i % sampleTags.length],
      );

      records.add(record);
    }

    return records;
  }

  factory Record.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<String> titleArr =
        (data['titleArr'] as List<dynamic>?)?.cast<String>() ?? [];
    String description = data['description']?.toLowerCase() ?? '';
    DateTime? date = (data['date'] as Timestamp?)?.toDate();
    String from = data['from'];
    String to = data['to'];
    String? priority = data['priority']?.toLowerCase() ?? '';
    List<String> tags = (data['tags'] as List<dynamic>?)?.cast<String>() ?? [];

    if (titleArr.isEmpty) {
      throw ArgumentError('titleArr cant be empty.');
    }

    if (!TimeService.isValidTimeFormat(from) ||
        !TimeService.isValidTimeFormat(to)) {
      throw ArgumentError('From/To must be of pattern hh:mm am/pm|AM/PM');
    }

    if (date is! DateTime) {
      throw ArgumentError('Date must be of type DateTime.');
    }

    if (priority != 'high' &&
        priority != 'mid' &&
        priority != 'low' &&
        priority != '') {
      throw ArgumentError(
          'priority must be one of "high", "mid", "low" or \' \'.');
    }

    if (tags.isEmpty) {
      throw ArgumentError('tags must not be empty.');
    }

    return Record(
      docId: doc.id,
      titleArr: titleArr,
      description: description,
      date: date,
      from: from,
      to: to,
      priority: priority,
      tags: tags,
    );
  }

  static assignPriority(String from, String to) {
    DateFormat format = DateFormat('hh:mm a');
    DateTime fromTime = format.parse(from);
    DateTime toTime = format.parse(to);

    Duration difference = toTime.difference(fromTime).abs();
    // print("difference $difference");
    if (difference.inHours > 3) {
      return 'high';
    } else if (difference.inHours > 1 && difference.inHours <= 3) {
      return 'mid';
    } else if (difference.inHours <= 1) {
      return 'low';
    } else {
      return '';
    }
  }

  static int comparePriority(String? priorityA, String? priorityB) {
    Map<String, int> priorityOrder = {
      'high': 3,
      'mid': 2,
      'low': 1,
      '': 0,
    };
    int valueA = priorityOrder[priorityA ?? ''] ?? 0;
    int valueB = priorityOrder[priorityB ?? ''] ?? 0;
    return valueB - valueA;
  }

  static List<Record> sortByPriority(List<Record> records) {
    records.sort((a, b) {
      return comparePriority(a.priority, b.priority);
    });
    return records;
  }

  @override
  String toString() {
    return 'Record{'
        'docId: $docId, '
        'titleArr: $titleArr, '
        'description: $description, '
        'date: $date, '
        'from: $from, '
        'to: $to, '
        'priority: $priority, '
        'tags: $tags}';
  }
}
