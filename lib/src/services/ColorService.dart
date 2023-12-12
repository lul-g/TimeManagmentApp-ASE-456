import 'package:flutter/material.dart';
import 'package:time_app/src/utils/constants.dart';

class ColorService {
  static Color getColorForPriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return KThemeColors.redDark;
      case 'mid':
        return KThemeColors.yellowDark;
      case 'low':
        return KThemeColors.blueDark;
      default:
        return KThemeColors.teritiary;
    }
  }
}
