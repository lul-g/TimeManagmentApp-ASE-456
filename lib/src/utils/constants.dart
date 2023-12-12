// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 100.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 60.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);

const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
);

const kTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(
    Icons.location_city,
    color: Colors.white,
  ),
  hintText: 'Enter City Name',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide.none,
  ),
);

class KThemeColors {
  static const Color yellowLight = Color(0xFFFFF7EC);
  static const Color yellow = Color(0xFFFAF0DA);
  static const Color yellowDark = Color(0xFFEBBB7F);

  static const Color redLight = Color(0xFFFCF0F0);
  static const Color red = Color(0xFFFBE4E6);
  static const Color redDark = Color(0xFFF08A8E);

  static const Color blueLight = Color(0xFFEDF4FE);
  static const Color blue = Color(0xFFE1EDFC);
  static const Color blueDark = Color.fromARGB(255, 133, 171, 247);

  static const Color primary = Color(0xFF1B1D20);
  static const Color secondary = Color(0xFFFFFFFF);
  static const Color teritiary = Color(0XFFF2F4F6);
}

class KThemeBorders {
  static final Border border_sm = Border.all(
    color: Colors.white,
    width: 0.2,
  );
  static final Border border_md = Border.all(
    color: Colors.white,
    width: 0.8,
  );
  static final Border border_lg = Border.all(
    color: Colors.white,
    width: 1.2,
  );
}

class KThemeBorderRadius {
  static final BorderRadius borderRadius_xs = BorderRadius.circular(6.0);
  static final BorderRadius borderRadius_sm = BorderRadius.circular(8.0);
  static final BorderRadius borderRadius_md = BorderRadius.circular(16.0);
  static final BorderRadius borderRadius_lg = BorderRadius.circular(24.0);
  static final BorderRadius borderRadius_xl = BorderRadius.circular(32.0);
}

const KMainFlexGap = 10.0;

class KCustomImages {
  // static const String logo = 'lib/assets/images/1.png';
}
