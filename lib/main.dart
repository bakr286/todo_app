import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/providers/theme_provider.dart';
import 'data/themes.dart';
import 'screens/structure.dart';
import 'services/database.dart';
import 'services/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().initializeNotification();

  await TodoDatabase().initializeDatabase();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => taskProvider),
        ChangeNotifierProvider(create: (_) => timerProvider),
        ChangeNotifierProvider(create: (_) => themeProvider),
      ],
      child: Consumer(
        builder: (context, ThemeProvider themeProvider, child) => MaterialApp(
          title: 'Todo App',
          theme: themeProvider.currentTheme,
          debugShowCheckedModeBanner: false,
          home: Structure(),
        )
      ),
    );
  }
}
