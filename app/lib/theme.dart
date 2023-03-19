import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'main.dart';

const kClassicThemePrimary = isNightly ? Color(0xFF00469E) : Color(0xFFf2b138);
const kClassicTheme = FlexSchemeColor(
    primary: kClassicThemePrimary, secondary: kClassicThemePrimary);
const kClassicThemeData = FlexSchemeData(
    name: '', description: '', light: kClassicTheme, dark: kClassicTheme);

ThemeData getThemeData(String name, bool dark, [ColorScheme? overridden]) {
  final color = getFlexThemeColor(name, dark);
  final override = overridden != null && name.isEmpty;
  if (dark) {
    return FlexThemeData.dark(
      colors: override ? null : color,
      colorScheme: override ? overridden : null,
      useMaterial3: true,
      appBarElevation: 2,
      fontFamily: 'Comfortaa',
    );
  }
  return FlexThemeData.light(
    colors: override ? null : color,
    colorScheme: override ? overridden : null,
    useMaterial3: true,
    appBarElevation: 0.5,
    fontFamily: 'Comfortaa',
  );
}

FlexSchemeColor getFlexThemeColor(String name, bool dark) {
  final color = FlexColor.schemesList.firstWhere(
      (scheme) => scheme.name == name,
      orElse: () => kClassicThemeData);
  if (dark) return color.dark;
  return color.light;
}

List<String> getThemes() {
  return FlexColor.schemesList.map((e) => e.name).toList();
}