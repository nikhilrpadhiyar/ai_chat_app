import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  void showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(this).colorScheme.error : null,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

extension StringX on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String get titleCase => split(' ').map((String w) => w.capitalize).join(' ');
  bool get isValidEmail => RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(this);
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}...';
}

extension DateTimeX on DateTime {
  String get timeLabel {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime date = DateTime(year, month, day);
    if (date == today) return DateFormat.jm().format(this);
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (now.difference(this).inDays < 7) return DateFormat.EEEE().format(this);
    return DateFormat.yMMMd().format(this);
  }

  String get chatDateHeader {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime date = DateTime(year, month, day);
    if (date == today) return 'Today';
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat.yMMMEd().format(this);
  }

  String get timeOnly => DateFormat.jm().format(this);
}
