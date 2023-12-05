import 'dart:math';
import 'package:flutter/material.dart';
import 'package:time_app/src/utils/constants.dart';

enum AppColor { blueDark, blue, redDark, red, yellowDark, yellow, grey }

class ColorUtils {
  static const Map<AppColor, Color> colorMap = {
    AppColor.blueDark: KThemeColors.blueDark,
    AppColor.blue: KThemeColors.blue,
    AppColor.redDark: KThemeColors.redDark,
    AppColor.red: KThemeColors.red,
    AppColor.yellowDark: KThemeColors.yellowDark,
    AppColor.yellow: KThemeColors.yellow,
    AppColor.grey: Colors.grey,
  };

  static Color getRandomDarkColor() {
    final darkColors =
        AppColor.values.where((color) => color.toString().contains('Dark'));
    final randomDarkColorIndex = Random().nextInt(darkColors.length);
    final randomDarkColor = darkColors.elementAt(randomDarkColorIndex);
    return colorMap[randomDarkColor] ?? Colors.grey.withOpacity(0.1);
  }

  static Color getRandomColor() {
    final randomColorIndex = Random().nextInt(AppColor.values.length);
    final randomColor = AppColor.values[randomColorIndex];
    return colorMap[randomColor] ?? Colors.grey.withOpacity(0.1);
  }

  static AppColor getColorFromString(Color color) {
    for (var entry in ColorUtils.colorMap.entries) {
      if (entry.value == color) {
        return entry.key;
      }
    }
    return AppColor.grey;
  }

  static String colorToString(Color? color) {
    AppColor appColor = getColorFromString(color!);
    switch (appColor) {
      case AppColor.blue:
        return 'blue';
      case AppColor.red:
        return 'red';
      case AppColor.yellow:
        return 'yellow';
      case AppColor.blueDark:
        return 'blueDark';
      case AppColor.redDark:
        return 'redDark';
      case AppColor.yellowDark:
        return 'yellowDark';
      case AppColor.grey:
        return 'grey';
      default:
        return 'grey';
    }
  }

  static Color stringToColor(String colorString) {
    switch (colorString) {
      case 'blue':
        return KThemeColors.blue;
      case 'red':
        return KThemeColors.red;
      case 'yellow':
        return KThemeColors.yellow;
      case 'blueDark':
        return KThemeColors.blueDark;
      case 'redDark':
        return KThemeColors.redDark;
      case 'yellowDark':
        return KThemeColors.yellowDark;
      case 'grey':
        return Colors.grey.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }
}
