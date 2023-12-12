import 'package:flutter/material.dart';
import 'package:time_app/src/models/record.dart';
import 'package:time_app/src/services/FirebaseService.dart';
import 'package:time_app/src/utils/constants.dart';
import 'package:time_app/src/services/TimeService.dart';

class AddRecord extends StatefulWidget {
  final Function updateRecords;
  final Function getRecords;
  const AddRecord({
    super.key,
    required this.updateRecords,
    required this.getRecords,
  });

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedFrom = TimeOfDay.now();
  TimeOfDay selectedTo = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth <= 600;
    return Container(
      width: isMobile ? screenWidth : screenWidth / 2,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: KThemeColors.primary,
        borderRadius: KThemeBorderRadius.borderRadius_md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: tagsController,
            decoration:
                const InputDecoration(labelText: 'Tags (comma-separated)'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date',
              suffixIcon: Icon(
                Icons.calendar_month,
              ),
            ),
            onTap: () => _selectDate(context),
            controller: TextEditingController(
              text: TimeService.standardDate(selectedDate),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'From',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () => _selectFrom(context),
                  controller: TextEditingController(
                    text: selectedFrom.format(context),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'To',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () => _selectTo(context),
                  controller: TextEditingController(
                    text: selectedTo.format(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: KThemeColors.secondary,
              foregroundColor: KThemeColors.primary,
            ),
            onPressed: () async {
              Record record = Record(
                titleArr: titleController.text.split(' '),
                date: DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                ),
                from: TimeService.timeOfDayToString(selectedFrom),
                to: TimeService.timeOfDayToString(selectedTo),
                description: descriptionController.text,
                priority: Record.assignPriority(
                    TimeService.timeOfDayToString(selectedFrom),
                    TimeService.timeOfDayToString(selectedTo)),
                tags: tagsController.text.split(','),
              );
              await FirebaseService.setData(record);
              widget.updateRecords(await FirebaseService.fetchAllRecords());
              Navigator.pop(context);
            },
            child: const Text('Add Record'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectFrom(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedFrom,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: KThemeColors.primary,
            hintColor: KThemeColors.secondary,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedFrom = pickedTime;
      });
    }
  }

  Future<void> _selectTo(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedFrom,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: KThemeColors.primary,
            hintColor: KThemeColors.secondary,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedTo = pickedTime;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
