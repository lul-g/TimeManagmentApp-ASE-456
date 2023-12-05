import 'package:flutter/material.dart';
import 'package:time_app/src/models/record.dart';
import 'package:time_app/src/services/TimeUtils.dart';
import 'package:time_app/src/services/StringExtensions.dart';
import 'package:time_app/src/utils/constants.dart';

class RecordCard extends StatelessWidget {
  final Record record;

  const RecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: KThemeBorderRadius.borderRadius_sm,
        color: record.bgColor,
      ),
      padding: const EdgeInsets.all(10),
      child: record.title != ''
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      record.title != '' ? record.title!.capitalize() : '',
                      style: const TextStyle(
                        color: KThemeColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      record.title != ''
                          ? TimeUtils.formatTime(record.dateTime!)
                          : '',
                      style: const TextStyle(color: KThemeColors.primary),
                    ),
                  ],
                ),
                Text(
                  record.slot!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: (record.tags ?? []).map((tag) {
                    return Container(
                      margin: const EdgeInsets.only(right: 5.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: record.bgColor,
                        borderRadius: KThemeBorderRadius.borderRadius_lg,
                        border: KThemeBorders.border_md,
                      ),
                      child: Text(
                        "#${tag.capitalize()}",
                        style: const TextStyle(
                          color: KThemeColors.primary,
                        ),
                      ),
                    );
                  }).toList(),
                )
              ],
            )
          : null,
    );
  }
}
