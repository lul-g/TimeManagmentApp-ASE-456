import 'package:flutter_test/flutter_test.dart';
import 'package:time_app/src/services/ColorService.dart';
import 'package:time_app/src/utils/constants.dart';

void main() {
  test('getColorForPriority should return the correct color based on priority',
      () {
    expect(ColorService.getColorForPriority('high'), KThemeColors.redDark);
    expect(ColorService.getColorForPriority('mid'), KThemeColors.yellowDark);
    expect(ColorService.getColorForPriority('low'), KThemeColors.blueDark);
    expect(ColorService.getColorForPriority(null), KThemeColors.teritiary);
    expect(ColorService.getColorForPriority('invalid'), KThemeColors.teritiary);
  });
}
