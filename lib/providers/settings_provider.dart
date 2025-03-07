import 'package:flutter/material.dart';
import '../models/settings_model.dart';

class SettingsProvider extends ChangeNotifier {
  CalculatorSettings _settings = CalculatorSettings();
  bool _isLoading = true;

  SettingsProvider() {
    _loadSettings();
  }

  // Getter for settings
  CalculatorSettings get settings => _settings;
  
  // Getter for loading state
  bool get isLoading => _isLoading;

  // Load settings from shared preferences
  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();
    
    _settings = await CalculatorSettings.loadFromPrefs();
    
    _isLoading = false;
    notifyListeners();
  }

  // Update settings
  Future<void> updateSettings(CalculatorSettings newSettings) async {
    _settings = newSettings;
    await _settings.saveToPrefs();
    notifyListeners();
  }

  // Update a single setting
  Future<void> updateSetting<T>({
    required String settingName,
    required T value,
  }) async {
    switch (settingName) {
      case 'themeMode':
        if (value is ThemeMode) {
          _settings = _settings.copyWith(themeMode: value);
        }
        break;
      case 'maxDecimalPlaces':
        if (value is int) {
          _settings = _settings.copyWith(maxDecimalPlaces: value);
        }
        break;
      case 'useThousandsSeparator':
        if (value is bool) {
          _settings = _settings.copyWith(useThousandsSeparator: value);
        }
        break;
      case 'useScientificNotation':
        if (value is bool) {
          _settings = _settings.copyWith(useScientificNotation: value);
        }
        break;
      case 'enableVibration':
        if (value is bool) {
          _settings = _settings.copyWith(enableVibration: value);
        }
        break;
      case 'enableSounds':
        if (value is bool) {
          _settings = _settings.copyWith(enableSounds: value);
        }
        break;
      case 'buttonRadius':
        if (value is double) {
          _settings = _settings.copyWith(buttonRadius: value);
        }
        break;
      case 'accentColorHex':
        if (value is String) {
          _settings = _settings.copyWith(accentColorHex: value);
        }
        break;
      case 'saveCalculationHistory':
        if (value is bool) {
          _settings = _settings.copyWith(saveCalculationHistory: value);
        }
        break;
      case 'maxHistoryItems':
        if (value is int) {
          _settings = _settings.copyWith(maxHistoryItems: value);
        }
        break;
    }
    
    await _settings.saveToPrefs();
    notifyListeners();
  }
} 