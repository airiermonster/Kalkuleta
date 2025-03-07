import 'package:intl/intl.dart';
import '../models/settings_model.dart';

class NumberFormatter {
  static String formatResult(double value, CalculatorSettings settings) {
    // Handle scientific notation if enabled and value is very large or small
    if (settings.useScientificNotation && 
        (value.abs() > 10000000 || (value.abs() < 0.0000001 && value != 0))) {
      return value.toStringAsExponential(settings.maxDecimalPlaces);
    }
    
    // Format with appropriate decimal places
    String formattedValue;
    
    // Check if it's an integer
    if (value == value.toInt()) {
      formattedValue = value.toInt().toString();
    } else {
      // Format with decimal places
      formattedValue = value.toStringAsFixed(settings.maxDecimalPlaces);
      
      // Remove trailing zeros
      while (formattedValue.contains('.') && 
             formattedValue.endsWith('0')) {
        formattedValue = formattedValue.substring(0, formattedValue.length - 1);
      }
      
      // Remove decimal point if it's the last character
      if (formattedValue.endsWith('.')) {
        formattedValue = formattedValue.substring(0, formattedValue.length - 1);
      }
    }
    
    // Add thousands separator if enabled
    if (settings.useThousandsSeparator) {
      final parts = formattedValue.split('.');
      final integerPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
      
      final formatter = NumberFormat('#,###');
      final formattedInteger = formatter.format(int.parse(integerPart));
      
      formattedValue = formattedInteger + decimalPart;
    }
    
    return formattedValue;
  }
} 