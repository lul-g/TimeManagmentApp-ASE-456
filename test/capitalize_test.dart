import 'package:flutter_test/flutter_test.dart';
import 'package:time_app/src/services/StringExtensions.dart';

void main() {
  test(
      'capitalize should capitalize the first letter and convert the rest to lowercase',
      () {
    expect('hello'.capitalize(), 'Hello');
    expect('wORLD'.capitalize(), 'World');
    expect('cAPITALIZE'.capitalize(), 'Capitalize');
    expect(''.capitalize(), '');
  });
}
