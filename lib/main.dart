import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/themes.dart';
import 'screens/structure.dart';
import 'services/database.dart';
import 'services/task_provider.dart';
import 'services/notifications.dart';  // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Add this line
  
  try {
    await NotificationService().initializeNotification();
  } catch (e) {
    print('Failed to initialize notifications: $e');
    // Handle permission denied scenario
  }
  
  await TodoDatabase().initializeDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: Structure(),
    );
  }
}
