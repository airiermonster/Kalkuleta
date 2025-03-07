import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_model.dart';
import '../models/settings_model.dart';

class HistoryProvider extends ChangeNotifier {
  List<Calculation> _history = [];
  bool _isLoading = true;
  
  HistoryProvider() {
    _loadHistory();
  }
  
  // Getter for history
  List<Calculation> get history => _history;
  
  // Getter for loading state
  bool get isLoading => _isLoading;
  
  // Load history from shared preferences
  Future<void> _loadHistory() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('calculationHistory') ?? [];
    
    _history = historyJson
        .map((item) => Calculation.fromJson(jsonDecode(item)))
        .toList();
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Save history to shared preferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    
    final historyJson = _history
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    
    await prefs.setStringList('calculationHistory', historyJson);
  }
  
  // Add a calculation to history
  Future<void> addCalculation(Calculation calculation, CalculatorSettings settings) async {
    if (!settings.saveCalculationHistory) return;
    
    _history.insert(0, calculation);
    
    // Limit history size
    if (_history.length > settings.maxHistoryItems) {
      _history = _history.sublist(0, settings.maxHistoryItems);
    }
    
    await _saveHistory();
    notifyListeners();
  }
  
  // Clear history
  Future<void> clearHistory() async {
    _history.clear();
    await _saveHistory();
    notifyListeners();
  }
  
  // Delete a specific calculation
  Future<void> deleteCalculation(int index) async {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
      await _saveHistory();
      notifyListeners();
    }
  }
} 