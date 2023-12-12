// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:time_app/src/utils/constants.dart';

class ToastService {
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFFFF00b09b),
      webBgColor: "linear-gradient(to right, #00b09b, #00b09b)",
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 3,
      backgroundColor: KThemeColors.yellowDark,
      webBgColor: "linear-gradient(to right, #FFF08A8E, #ffcc00)",
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 3,
      backgroundColor: KThemeColors.redDark,
      webBgColor: "linear-gradient(to right, #FC466B, #FC466B)",
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
