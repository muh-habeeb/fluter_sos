import 'package:flutter/material.dart';

extension ColorExtension on String {
  Color toColor() {
    final hexColor = replaceAll("#", "");
    return Color(int.parse('FF$hexColor', radix: 16));
  }
}
