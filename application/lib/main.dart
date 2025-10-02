import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quote_tab_todo/models/task.dart';
import 'package:quote_tab_todo/screens/login_screen.dart';
import 'package:quote_tab_todo/screens/todo_list_screen.dart';
import 'package:quote_tab_todo/services/version_service.dart';
import 'package:quote_tab_todo/widgets/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quote Tab Todo',
      theme: ThemeData(
        textTheme: GoogleFonts.cairoTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF11151E)),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final String currentUsername;
  late final bool isUpdated;

  @override
  void initState() {
    super.initState();
    _getCurrentUsername();
    _checkLoginAndNavigate();
  }

  Future<void> _getCurrentUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUsername = prefs.getStringList('currentUser')?[0] ?? 'unknown';
  }

  //new: checks for latest update
  Future<void> _checkLoginAndNavigate() async {
    await _isLastUpdated();
    if (isUpdated) {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        // Add a small delay to ensure everything is loaded
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => isLoggedIn
                  ? TodoListScreen(username: currentUsername)
                  : const LoginScreen(),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    }
  }

  Future<void> _isLastUpdated() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final androidVersion = info.version;
    final latestAndroidVersion = await VersionService.androidVersion();

    print(androidVersion);
    print("----");
    print(latestAndroidVersion);

    if (androidVersion == latestAndroidVersion) {
      isUpdated = true;
    } else if (latestAndroidVersion != 'error') {
      isUpdated = false;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 37, 45, 65),
            title: Text("Update Available!"),
            content: Text('Please Update The Application'),
            actions: [
              TextButton(
                onPressed: () async {
                  final url = Uri.parse('https://quote-tab.netlify.app/');
                  final success = await _launchUrl(url);
                  if (!success && mounted) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: const Color.fromARGB(255, 37, 45, 65),
                          title: Text("Error"),
                          content: Text(
                            "Failed to connect to the internet, Please try again later.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (Platform.isAndroid) {
                                  SystemNavigator.pop();
                                }
                              },
                              child: Text('Exit'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Update'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 37, 45, 65),
            title: Text('Error'),
            content: Text(
              'Failed to connect to the internet, Please try again later.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  }
                },
                child: Text('Exit'),
              ),
            ],
          );
        },
      );
      isUpdated = false;
    }
  }

  Future<bool> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF11151E),
      body: LoadingWidget(),
    );
  }
}
