import 'package:flutter/material.dart';
import 'package:time_app/src/models/record.dart';
import 'package:time_app/src/services/ColorService.dart';
import 'package:time_app/src/services/FirebaseService.dart';
import 'package:time_app/src/services/TimeService.dart';
import 'package:time_app/src/services/StringExtensions.dart';
import 'package:time_app/src/utils/constants.dart';

class RecordCard extends StatelessWidget {
  final Record record;
  final Function updateRecordList;

  const RecordCard(
      {super.key, required this.record, required this.updateRecordList});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth <= 600;
    return GestureDetector(
      onTap: () => _showDetailsDialog(context),
      child: Container(
        // width: 250,
        decoration: BoxDecoration(
          borderRadius: KThemeBorderRadius.borderRadius_sm,
          color: KThemeColors.primary,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: isMobile ? 200 : 300,
                      child: Text(
                        record.titleArr.join(' ').capitalize(),
                        style: const TextStyle(
                          color: KThemeColors.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: KThemeBorderRadius.borderRadius_xs,
                            color: KThemeColors.teritiary,
                          ),
                          child: Text(
                            TimeService.dateToStr_ux(record.date),
                            style: const TextStyle(
                              color: KThemeColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: KThemeBorderRadius.borderRadius_xs,
                            color: KThemeColors.teritiary,
                          ),
                          child: Text(
                            "${record.from} - ${record.to}",
                            style: const TextStyle(
                              color: KThemeColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: ColorService.getColorForPriority(record.priority),
                    borderRadius: KThemeBorderRadius.borderRadius_xs,
                  ),
                  child: Text(
                    record.priority?.capitalize() ?? '',
                    style: const TextStyle(color: KThemeColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              record.description?.capitalize() ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 5.0,
              runSpacing: 10.0,
              children: (record.tags ?? []).map((tag) {
                return Container(
                  margin: const EdgeInsets.only(right: 5.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: KThemeColors.teritiary,
                    borderRadius: KThemeBorderRadius.borderRadius_xs,
                    border: KThemeBorders.border_md,
                  ),
                  child: Text(
                    "#${tag.capitalize()}",
                    style: const TextStyle(
                      color: KThemeColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: KThemeBorderRadius.borderRadius_sm,
          ),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width < 600
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 3,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: KThemeColors.secondary,
                  borderRadius: KThemeBorderRadius.borderRadius_sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 220,
                        child: Text(
                          record.titleArr.join(' ').capitalize(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: KThemeColors.primary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KThemeColors.redDark,
                          foregroundColor: KThemeColors.primary,
                        ),
                        onPressed: () {
                          _showDeleteConfirmation(context);
                          // Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    record.description?.capitalize() ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      color: KThemeColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.dangerous,
                color: Colors.red,
              ),
              SizedBox(width: 8),
              Text(
                'Delete Confirmation',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete?',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: KThemeColors.primary,
          shape: RoundedRectangleBorder(
              borderRadius: KThemeBorderRadius.borderRadius_sm),
          actions: [
            TextButton(
              onPressed: () async {
                FirebaseService.deleteRecord(record.docId!);
                updateRecordList(await FirebaseService.fetchAllRecords());
                print(
                    'Hello, delete ${record.docId} - ${record.titleArr.join(' ')}!');
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
