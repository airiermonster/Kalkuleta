# Kalkuleta

A beautiful modern calculator app built with Flutter, featuring customizable settings and a professional design.

## Features

- Clean and modern UI design with animations
- Light, dark, and system theme support
- Customizable accent colors
- Basic arithmetic operations (addition, subtraction, multiplication, division)
- Parentheses support for complex expressions
- Calculation history with the ability to reuse previous calculations
- Customizable settings:
  - Decimal places (0-10)
  - Thousands separator
  - Scientific notation for large numbers
  - Button roundness
  - Haptic feedback
  - Theme selection
- Responsive layout that works on all screen sizes
- Error handling for invalid expressions

## Getting Started

1. Make sure you have Flutter installed on your machine
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app on your connected device or emulator

## Dependencies

- [math_expressions](https://pub.dev/packages/math_expressions): For parsing and evaluating mathematical expressions
- [google_fonts](https://pub.dev/packages/google_fonts): For beautiful typography
- [provider](https://pub.dev/packages/provider): For state management
- [shared_preferences](https://pub.dev/packages/shared_preferences): For storing user preferences
- [intl](https://pub.dev/packages/intl): For number and date formatting
- [flutter_vibrate](https://pub.dev/packages/flutter_vibrate): For haptic feedback

## Project Structure

```
lib/
├── models/
│   ├── calculation_model.dart
│   └── settings_model.dart
├── providers/
│   ├── history_provider.dart
│   └── settings_provider.dart
├── screens/
│   ├── calculator_screen.dart
│   ├── history_screen.dart
│   └── settings_screen.dart
├── utils/
│   └── number_formatter.dart
└── main.dart
```

## License

This project is open source and available under the MIT License.
