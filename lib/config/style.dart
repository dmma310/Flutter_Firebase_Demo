
import 'package:flutter/material.dart';

const String fontNameBusinessCardScreen = 'Open-Sans';
const double titleTextSize = 24.0;
const FontWeight titleFontWeight = FontWeight.w800;
const double bodyTextSize = 14.0;
const double body2TextSize = 21.0;
const FontStyle bodyFontStyle = FontStyle.italic;
const FontWeight defaultFontWeight = FontWeight.w600;
const Color defaultTextColor = Colors.white;
const Color darkModeTextColor = Colors.grey;
const double appbarTextSize = 30.0;
Color businessCardScreenBackgroundColor = Colors.grey[850];


ThemeData mainTheme({@required bool isDarkMode}) {
  return ThemeData(
    primarySwatch: Colors.blue,
    appBarTheme: const AppBarTheme(
      textTheme: _appBarTextTheme, // Use style defined in config/style.dart
    ),
    brightness: isDarkMode ? Brightness.dark : Brightness.light, // Set brightness based on user selection
    textTheme: isDarkMode ? _textThemeDark : _textThemeLight,
  );
}

const _appBarTextTheme = const TextTheme(
  headline1: const TextStyle(
    fontWeight: defaultFontWeight,
    fontSize: appbarTextSize,
    color: defaultTextColor,
  ),
);

const _textThemeLight = const TextTheme(
  headline1: const TextStyle(
    fontWeight: titleFontWeight,
    fontSize: titleTextSize,
    color: darkModeTextColor,
  ),
  bodyText1: const TextStyle(
    fontWeight: defaultFontWeight,
    fontSize: bodyTextSize,
    color: darkModeTextColor,
    fontStyle: bodyFontStyle,
  ),
);

const _textThemeDark = const TextTheme(
  headline1: const TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: titleTextSize,
    color: defaultTextColor,
  ),
  bodyText1: const TextStyle(
    fontWeight: defaultFontWeight,
    fontSize: bodyTextSize,
    color: defaultTextColor,
    fontStyle: bodyFontStyle,
  ),
);

// Define custom text style for businesscard screen
const BusinessCardScreenHeaderTextStyle = TextStyle(
  fontFamily: fontNameBusinessCardScreen,
  fontWeight: FontWeight.w600,
  fontSize: body2TextSize,
);

const BusinessScreenBodyTextStyle = TextStyle(
  fontFamily: fontNameBusinessCardScreen,
  fontWeight: FontWeight.w300,
  fontSize: bodyTextSize,
  fontStyle: FontStyle.italic,
);