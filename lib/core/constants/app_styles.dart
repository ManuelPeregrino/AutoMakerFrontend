import 'package:flutter/material.dart';

class AppStyles {
  // Define the main colors used in your app
  static const Color primaryColor =
      Color(0xFFFFA500); // Orange accent color for buttons and highlights
  static const Color accentColor = Colors.blue; // Define an accent color
  static const Color backgroundColor =
      Color(0xFFF5F5F5); // Light grey background
  static const Color textColor = Color(0xFF333333); // Dark grey for main text
  static const Color subtitleColor =
      Color(0xFF888888); // Lighter grey for subtitles
  static const Color iconColor = Colors.black87; // Slightly darker icons
  static const Color cardColor = Colors.white; // White background for cards
  static const Color borderColor = Color(0xFFE0E0E0); // Light border color

  // Define the textTheme for the app
  static const TextTheme textTheme = TextTheme(
    displayLarge: headline1,
    displayMedium: headline2,
    displaySmall: headline3,
    titleMedium: subtitle,
    bodyLarge: bodyText,
    labelLarge: buttonText,
  );

  // Text styles
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: subtitleColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  // Box decorations
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 4,
        offset: const Offset(0, 2), // Changes position of shadow
      ),
    ],
  );

  // Button styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor, // Use 'backgroundColor' instead of 'primary'
    foregroundColor:
        Colors.white, // Use 'foregroundColor' instead of 'onPrimary'
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
  );

  // Input decoration
  static final InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: primaryColor),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  );
}
