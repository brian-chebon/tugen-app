import 'package:flutter/material.dart';

/// BuildContext extensions for quick access
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;

  void showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

/// Duration formatting
extension DurationExtensions on Duration {
  String get formatted {
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    if (inHours > 0) {
      return '$inHours:$m:$s';
    }
    return '$m:$s';
  }

  String get humanReadable {
    if (inMinutes < 1) return '${inSeconds}s';
    if (inMinutes < 60) return '${inMinutes}m';
    if (inHours < 24) return '${inHours}h';
    if (inDays < 30) return '${inDays}d';
    return '${(inDays / 30).round()}mo';
  }
}

/// String extensions
extension StringExtensions on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}...';
}

/// Number formatting
extension IntExtensions on int {
  String get compactFormat {
    if (this < 1000) return toString();
    if (this < 1000000) return '${(this / 1000).toStringAsFixed(1)}K';
    return '${(this / 1000000).toStringAsFixed(1)}M';
  }
}
