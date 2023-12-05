import 'package:flutter/material.dart';
import 'package:time_app/src/models/record.dart';
import 'package:time_app/src/services/ColorUtils.dart';
import 'package:time_app/src/services/FirebaseUtils.dart';
import 'package:time_app/src/services/TimeUtils.dart';

class AddRecord extends StatefulWidget {
  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController slotController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: slotController,
            decoration: InputDecoration(labelText: 'Slot'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: tagsController,
            decoration:
                const InputDecoration(labelText: 'Tags (comma-separated)'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date',
              suffixIcon: Icon(Icons.calendar_month),
            ),
            onTap: () => _selectDate(context),
            controller: TextEditingController(
              text: selectedDate.toString(),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Time',
              suffixIcon: Icon(Icons.access_time),
            ),
            onTap: () => _selectTime(context),
            controller: TextEditingController(
              text: selectedTime.format(context),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Record record = Record(
                title: titleController.text,
                dateTime: DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                ),
                slot: slotController.text,
                bgColor: ColorUtils.getRandomColor(),
                tags: tagsController.text.split(','),
              );

              print(record);

              FirebaseUtils.setData(record);
              Navigator.pop(context);
            },
            child: Text('Add Record'),
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

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    slotController.dispose();
    super.dispose();
  }
}
