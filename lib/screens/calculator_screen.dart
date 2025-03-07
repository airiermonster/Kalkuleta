import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';
import '../models/calculation_model.dart';
import '../models/settings_model.dart';
import '../providers/settings_provider.dart';
import '../providers/history_provider.dart';
import '../utils/number_formatter.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> with SingleTickerProviderStateMixin {
  String _input = '';
  String _result = '';
  bool _showResult = false;
  late AnimationController _animationController;
  late Animation<double> _buttonPressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _buttonPressAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onButtonPressed(String buttonText, SettingsProvider settingsProvider, HistoryProvider historyProvider) {
    final settings = settingsProvider.settings;
    
    // Provide haptic feedback if enabled
    if (settings.enableVibration) {
      HapticFeedback.lightImpact();
    }
    
    setState(() {
      if (buttonText == 'C') {
        _input = '';
        _result = '';
        _showResult = false;
      } else if (buttonText == '⌫') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (buttonText == '=') {
        try {
          _calculateResult(settings);
          _showResult = true;
          
          // Add to history
          if (_input.isNotEmpty && _result.isNotEmpty) {
            final calculation = Calculation(
              expression: _input,
              result: _result,
            );
            historyProvider.addCalculation(calculation, settings);
          }
        } catch (e) {
          _result = 'Error';
        }
      } else {
        if (_showResult) {
          if ('+-×÷'.contains(buttonText)) {
            _input = _result + buttonText;
          } else {
            _input = buttonText;
          }
          _showResult = false;
        } else {
          _input += buttonText;
        }
      }
    });
  }

  void _calculateResult(CalculatorSettings settings) {
    String finalInput = _input.replaceAll('×', '*').replaceAll('÷', '/');
    
    Parser p = Parser();
    Expression exp = p.parse(finalInput);
    ContextModel cm = ContextModel();
    
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    
    // Format the result using the formatter utility
    _result = NumberFormatter.formatResult(eval, settings);
  }

  void _showHistoryScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
    
    if (result != null && result is Calculation) {
      setState(() {
        _input = result.expression;
        _result = result.result;
        _showResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final settings = settingsProvider.settings;
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = settings.accentColor;
    final backgroundColor = Theme.of(context).colorScheme.background;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kalkuleta',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: primaryColor.withOpacity(0.7),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.history),
                              onPressed: _showHistoryScreen,
                              tooltip: 'History',
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                                );
                              },
                              tooltip: 'Settings',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      _input,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _showResult ? _result : '',
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ),
            
            // Buttons area
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? Colors.grey[900] 
                      : Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildButtonRow(['C', '(', ')', '÷'], settingsProvider, historyProvider),
                    _buildButtonRow(['7', '8', '9', '×'], settingsProvider, historyProvider),
                    _buildButtonRow(['4', '5', '6', '-'], settingsProvider, historyProvider),
                    _buildButtonRow(['1', '2', '3', '+'], settingsProvider, historyProvider),
                    _buildButtonRow(['0', '.', '⌫', '='], settingsProvider, historyProvider),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons, SettingsProvider settingsProvider, HistoryProvider historyProvider) {
    return Expanded(
      child: Row(
        children: buttons.map((buttonText) {
          return _buildButton(buttonText, settingsProvider, historyProvider);
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String buttonText, SettingsProvider settingsProvider, HistoryProvider historyProvider) {
    final settings = settingsProvider.settings;
    
    bool isOperator = '+-×÷'.contains(buttonText);
    bool isClear = buttonText == 'C';
    bool isEquals = buttonText == '=';
    bool isBackspace = buttonText == '⌫';
    bool isSpecial = isOperator || isClear || isEquals || isBackspace || buttonText == '(' || buttonText == ')';
    
    Color buttonColor;
    Color textColor;
    final primaryColor = settings.accentColor;
    
    if (isEquals) {
      buttonColor = primaryColor;
      textColor = Colors.white;
    } else if (isOperator) {
      buttonColor = Theme.of(context).colorScheme.primaryContainer;
      textColor = primaryColor;
    } else if (isClear || isBackspace) {
      buttonColor = Theme.of(context).colorScheme.errorContainer;
      textColor = Theme.of(context).colorScheme.error;
    } else if (buttonText == '(' || buttonText == ')') {
      buttonColor = Theme.of(context).colorScheme.secondaryContainer;
      textColor = Theme.of(context).colorScheme.secondary;
    } else {
      buttonColor = Theme.of(context).brightness == Brightness.dark 
          ? Colors.grey[800]! 
          : Colors.white;
      textColor = Theme.of(context).colorScheme.onSurface;
    }
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: buttonColor,
          borderRadius: BorderRadius.circular(settings.buttonRadius),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.3),
          child: InkWell(
            borderRadius: BorderRadius.circular(settings.buttonRadius),
            onTap: () => _onButtonPressed(buttonText, settingsProvider, historyProvider),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(settings.buttonRadius),
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: isSpecial ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 