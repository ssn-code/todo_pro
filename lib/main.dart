import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/task_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ProviderScope(child: MyApp()));
class MyApp extends ConsumerStatefulWidget { const MyApp({super.key}); @override ConsumerState<MyApp> createState() => _MyAppState(); }
class _MyAppState extends ConsumerState<MyApp> {
  ThemeMode _mode = ThemeMode.system;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final s = (await SharedPreferences.getInstance()).getString('theme_mode'); final m = ThemeMode.values.where((x) => x.name == s); if (mounted && m.isNotEmpty) setState(() => _mode = m.first); }
  Future<void> _set(ThemeMode m) async { setState(() => _mode = m); await (await SharedPreferences.getInstance()).setString('theme_mode', m.name); }
  @override Widget build(BuildContext context) => MaterialApp(title: 'Todo Pro', debugShowCheckedModeBanner: false, theme: AppTheme.light, darkTheme: AppTheme.dark, themeMode: _mode, home: TaskScreen(themeMode: _mode, onThemeChanged: _set));
}
