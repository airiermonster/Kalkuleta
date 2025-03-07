import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorSettings {
  // Theme settings
  ThemeMode themeMode;
  
  // Display settings
  int maxDecimalPlaces;
  bool useThousandsSeparator;
  bool useScientificNotation;
  
  // Vibration and sound
  bool enableVibration;
  bool enableSounds;
  
  // Appearance
  double buttonRadius;
  String accentColorHex;
  
  // History
  bool saveCalculationHistory;
  int maxHistoryItems;

  CalculatorSettings({
    this.themeMode = ThemeMode.system,
    this.maxDecimalPlaces = 8,
    this.useThousandsSeparator = true,
    this.useScientificNotation = false,
    this.enableVibration = true,
    this.enableSounds = false,
    this.buttonRadius = 24.0,
    this.accentColorHex = "6200EE",
    this.saveCalculationHistory = true,
    this.maxHistoryItems = 50,
  });

  // Get accent color from hex string
  Color get accentColor {
    return Color(int.parse("0xFF$accentColorHex"));
  }

  // Save settings to shared preferences
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt('themeMode', themeMode.index);
    await prefs.setInt('maxDecimalPlaces', maxDecimalPlaces);
    await prefs.setBool('useThousandsSeparator', useThousandsSeparator);
    await prefs.setBool('useScientificNotation', useScientificNotation);
    await prefs.setBool('enableVibration', enableVibration);
    await prefs.setBool('enableSounds', enableSounds);
    await prefs.setDouble('buttonRadius', buttonRadius);
    await prefs.setString('accentColorHex', accentColorHex);
    await prefs.setBool('saveCalculationHistory', saveCalculationHistory);
    await prefs.setInt('maxHistoryItems', maxHistoryItems);
  }

  // Load settings from shared preferences
  static Future<CalculatorSettings> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    return CalculatorSettings(
      themeMode: ThemeMode.values[prefs.getInt('themeMode') ?? ThemeMode.system.index],
      maxDecimalPlaces: prefs.getInt('maxDecimalPlaces') ?? 8,
      useThousandsSeparator: prefs.getBool('useThousandsSeparator') ?? true,
      useScientificNotation: prefs.getBool('useScientificNotation') ?? false,
      enableVibration: prefs.getBool('enableVibration') ?? true,
      enableSounds: prefs.getBool('enableSounds') ?? false,
      buttonRadius: prefs.getDouble('buttonRadius') ?? 24.0,
      accentColorHex: prefs.getString('accentColorHex') ?? "6200EE",
      saveCalculationHistory: prefs.getBool('saveCalculationHistory') ?? true,
      maxHistoryItems: prefs.getInt('maxHistoryItems') ?? 50,
    );
  }

  // Create a copy with some properties changed
  CalculatorSettings copyWith({
    ThemeMode? themeMode,
    int? maxDecimalPlaces,
    bool? useThousandsSeparator,
    bool? useScientificNotation,
    bool? enableVibration,
    bool? enableSounds,
    double? buttonRadius,
    String? accentColorHex,
    bool? saveCalculationHistory,
    int? maxHistoryItems,
  }) {
    return CalculatorSettings(
      themeMode: themeMode ?? this.themeMode,
      maxDecimalPlaces: maxDecimalPlaces ?? this.maxDecimalPlaces,
      useThousandsSeparator: useThousandsSeparator ?? this.useThousandsSeparator,
      useScientificNotation: useScientificNotation ?? this.useScientificNotation,
      enableVibration: enableVibration ?? this.enableVibration,
      enableSounds: enableSounds ?? this.enableSounds,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      saveCalculationHistory: saveCalculationHistory ?? this.saveCalculationHistory,
      maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
    );
  }
} 