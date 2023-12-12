import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_app/src/models/record.dart';
import 'package:time_app/src/services/FirebaseService.dart';
import 'package:time_app/src/services/TimeService.dart';
import 'package:time_app/src/utils/constants.dart';

class CalendarTableView extends StatefulWidget {
  final Function updateRecords;
  const CalendarTableView({required this.updateRecords, super.key});

  @override
  State<CalendarTableView> createState() => _CalendarTableViewState();
}

class _CalendarTableViewState extends State<CalendarTableView> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 680;
    return Container(
      width: isMobile
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width / 2,
      height: isMobile ? 360 : 350,
      decoration: BoxDecoration(
        color: KThemeColors.primary,
        borderRadius: KThemeBorderRadius.borderRadius_md,
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 10, 16),
        focusedDay: _focusedDay,
        locale: "en_US",
        rowHeight: 43,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        availableGestures: AvailableGestures.all,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        onDaySelected: _onDaySelected,
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    var standardDate = TimeService.standardDate(selectedDay);
    print('from calendar $standardDate');
    List<Record> records = await FirebaseService.getData("date:$standardDate");
    widget.updateRecords(records);
  }
}
