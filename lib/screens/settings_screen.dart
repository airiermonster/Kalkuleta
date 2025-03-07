import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/history_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final settings = settingsProvider.settings;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: settingsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Theme settings
                      _buildSectionHeader(context, 'Appearance'),
                      _buildThemeModeSetting(context, settingsProvider),
                      _buildSliderSetting(
                        context: context,
                        title: 'Button Roundness',
                        value: settings.buttonRadius,
                        min: 8.0,
                        max: 40.0,
                        divisions: 16,
                        onChanged: (value) {
                          settingsProvider.updateSetting(
                            settingName: 'buttonRadius',
                            value: value,
                          );
                        },
                      ),
                      _buildColorPicker(context, settingsProvider),
                      
                      const Divider(height: 32),
                      
                      // Display settings
                      _buildSectionHeader(context, 'Display'),
                      _buildSliderSetting(
                        context: context,
                        title: 'Decimal Places',
                        value: settings.maxDecimalPlaces.toDouble(),
                        min: 0,
                        max: 10,
                        divisions: 10,
                        onChanged: (value) {
                          settingsProvider.updateSetting(
                            settingName: 'maxDecimalPlaces',
                            value: value.toInt(),
                          );
                        },
                        valueDisplay: '${settings.maxDecimalPlaces}',
                      ),
                      _buildSwitchSetting(
                        context: context,
                        title: 'Use Thousands Separator',
                        subtitle: 'Display numbers with commas (e.g., 1,234,567)',
                        value: settings.useThousandsSeparator,
                        onChanged: (value) {
                          settingsProvider.updateSetting(
                            settingName: 'useThousandsSeparator',
                            value: value,
                          );
                        },
                      ),
                      _buildSwitchSetting(
                        context: context,
                        title: 'Scientific Notation',
                        subtitle: 'Use scientific notation for very large or small numbers',
                        value: settings.useScientificNotation,
                        onChanged: (value) {
                          settingsProvider.updateSetting(
                            settingName: 'useScientificNotation',
                            value: value,
                          );
                        },
                      ),
                      
                      const Divider(height: 32),
                      
                      // Feedback settings
                      _buildSectionHeader(context, 'Feedback'),
                      _buildSwitchSetting(
                        context: context,
                        title: 'Haptic Feedback',
                        subtitle: 'Vibrate when buttons are pressed',
                        value: settings.enableVibration,
                        onChanged: (value) {
                          settingsProvider.updateSetting(
                            settingName: 'enableVibration',
                            value: value,
                          );
                        },
                      ),
                      _buildSwitchSetting(
                        context: context,
                        title: 'Sound Effects',
                        subtitle: 'Play sounds when buttons are pressed',
                        value: settings.enableSounds,
                        onChanged: (value) {
                          settingsProvider.updateSetting(
                            settingName: 'enableSounds',
                            value: value,
                          );
                        },
                      ),
                      
                      const Divider(height: 32),
                      
                      // History settings
                      _buildSectionHeader(context, 'History'),
                      _buildSwitchSetting(
                        context: context,
                        title: 'Save Calculation History',
                        subtitle: 'Store your calculations for future reference',
                        value: settings.saveCalculationHistory,
                        onChanged: (value) {
                          settingsProvider.updateSetting(
                            settingName: 'saveCalculationHistory',
                            value: value,
                          );
                        },
                      ),
                      _buildSliderSetting(
                        context: context,
                        title: 'Maximum History Items',
                        value: settings.maxHistoryItems.toDouble(),
                        min: 10,
                        max: 100,
                        divisions: 9,
                        onChanged: (value) {
                          settingsProvider.updateSetting(
                            settingName: 'maxHistoryItems',
                            value: value.toInt(),
                          );
                        },
                        valueDisplay: '${settings.maxHistoryItems}',
                      ),
                      
                      // Clear history button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Clear History'),
                                content: const Text('Are you sure you want to clear your calculation history? This action cannot be undone.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      historyProvider.clearHistory();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('History cleared'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: const Text('CLEAR'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Clear Calculation History'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.errorContainer,
                            foregroundColor: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // About section
                      _buildSectionHeader(context, 'About'),
                      ListTile(
                        title: const Text('Kalkuleta'),
                        subtitle: const Text('Version 1.0.0'),
                        trailing: const Icon(Icons.info_outline),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'Kalkuleta',
                            applicationVersion: '1.0.0',
                            applicationIcon: const FlutterLogo(size: 48),
                            applicationLegalese: '© 2025 Kalkuleta',
                            children: [
                              const SizedBox(height: 16),
                              const Text(
                                'A beautiful modern calculator app with all basic functions.',
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Contact Information:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  // Open GitHub page (in a real app, you would use url_launcher package)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('GitHub: @airiermonster'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.code, size: 16, color: Theme.of(context).colorScheme.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      'GitHub: @airiermonster',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Footer with animated heart
                const AnimatedHeartFooter(),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildThemeModeSetting(BuildContext context, SettingsProvider settingsProvider) {
    final settings = settingsProvider.settings;
    
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildThemeOption(
                  context,
                  title: 'Light',
                  icon: Icons.light_mode,
                  isSelected: settings.themeMode == ThemeMode.light,
                  onTap: () {
                    settingsProvider.updateSetting(
                      settingName: 'themeMode',
                      value: ThemeMode.light,
                    );
                  },
                ),
                _buildThemeOption(
                  context,
                  title: 'Dark',
                  icon: Icons.dark_mode,
                  isSelected: settings.themeMode == ThemeMode.dark,
                  onTap: () {
                    settingsProvider.updateSetting(
                      settingName: 'themeMode',
                      value: ThemeMode.dark,
                    );
                  },
                ),
                _buildThemeOption(
                  context,
                  title: 'System',
                  icon: Icons.settings_suggest,
                  isSelected: settings.themeMode == ThemeMode.system,
                  onTap: () {
                    settingsProvider.updateSetting(
                      settingName: 'themeMode',
                      value: ThemeMode.system,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required BuildContext context,
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    String? valueDisplay,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                valueDisplay ?? value.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(BuildContext context, SettingsProvider settingsProvider) {
    final settings = settingsProvider.settings;
    
    // Predefined color options
    final colorOptions = [
      {"name": "Purple", "hex": "6200EE"},
      {"name": "Blue", "hex": "2196F3"},
      {"name": "Green", "hex": "4CAF50"},
      {"name": "Orange", "hex": "FF9800"},
      {"name": "Red", "hex": "F44336"},
      {"name": "Pink", "hex": "E91E63"},
      {"name": "Teal", "hex": "009688"},
      {"name": "Indigo", "hex": "3F51B5"},
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Accent Color',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colorOptions.map((color) {
              final isSelected = settings.accentColorHex.toUpperCase() == color["hex"];
              
              return InkWell(
                onTap: () {
                  settingsProvider.updateSetting(
                    settingName: 'accentColorHex',
                    value: color["hex"],
                  );
                  
                  // Provide haptic feedback if enabled
                  if (settings.enableVibration) {
                    HapticFeedback.lightImpact();
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(int.parse("0xFF${color["hex"]}")),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(int.parse("0xFF${color["hex"]}")).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class AnimatedHeartFooter extends StatefulWidget {
  const AnimatedHeartFooter({super.key});

  @override
  State<AnimatedHeartFooter> createState() => _AnimatedHeartFooterState();
}

class _AnimatedHeartFooterState extends State<AnimatedHeartFooter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Made with ',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: const Text(
                  '❤️',
                  style: TextStyle(fontSize: 14),
                ),
              );
            },
          ),
          Text(
            ' by Maxmillian Urio in Tanzania',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
} 