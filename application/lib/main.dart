import 'package:clean_quote_tab_todo/config/theme.dart';
import 'package:clean_quote_tab_todo/core/common/providers/prefs_provider.dart';
import 'package:clean_quote_tab_todo/features/tasks/data/models/task_model.dart';
import 'package:clean_quote_tab_todo/features/version_check/presentation/widgets/version_check_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasksBox');

  runApp(
    ProviderScope(
      overrides: [prefsProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      title: 'Quote Todo',
      home: VersionCheckGate(),);
  }
}
