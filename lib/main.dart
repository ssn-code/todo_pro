import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/task_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _themePreferenceKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    final savedMode = preferences.getString(_themePreferenceKey);
    final themeMode = ThemeMode.values.where((mode) => mode.name == savedMode);
    if (!mounted || themeMode.isEmpty) return;
    setState(() => _themeMode = themeMode.first);
  }

  Future<void> _setThemeMode(ThemeMode themeMode) async {
    setState(() => _themeMode = themeMode);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themePreferenceKey, themeMode.name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: TaskScreen(themeMode: _themeMode, onThemeChanged: _setThemeMode),
    );
  }
}
