import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../services/providers/task_provider.dart';
import '../services/providers/theme_provider.dart';
import '../services/providers/timer_provider.dart';
import 'add_edit_task_screen.dart';
import 'home.dart';
import 'settings.dart';
import 'timer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int index = 0;
var taskProvider = TaskProvider();
var timerProvider = TimerProvider();
var themeProvider = ThemeProvider();

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<TimerProvider>(
        builder: (context, timerProvider, child) {
          IconData buttonIcon;
          Color buttonColor = Theme.of(context).colorScheme.secondary;
          switch (index) {
            case 0:
              buttonIcon = Icons.add;
              buttonColor = Colors.red;
              break;
            case 1:
              buttonIcon = Icons.check;
              buttonColor = Colors.green;
              break;
            case 2:
              buttonIcon =
                  timerProvider.isRunning
                      ? Icons.pause
                      : Icons.play_arrow_sharp;
              buttonColor =
                  timerProvider.isRunning
                      ? Colors.yellow
                      : Theme.of(context).primaryColor;

              break;
            default:
              buttonIcon = Icons.add;
          }
          return FloatingActionButton(
            backgroundColor: buttonColor,
            onPressed: () async {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditTaskScreen(),
                    ),
                  );
                  break;
                case 1:
                  timerProvider.toggleTimer();
                  break;
                default:
              }
            },
            child: Icon(buttonIcon),
          );
        },
      ),
      body: screens[index],
      bottomNavigationBar: GNav(
        tabBackgroundColor: Theme.of(context).colorScheme.secondary,
        tabs: [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.timer, text: 'Timer'),
          GButton(icon: Icons.settings, text: 'Settings'),
        ],
        selectedIndex: index,
        onTabChange: (idx) {
          setState(() {
            index = idx;
          });
        },
      ),
    );
  }
}

List screens = [
  HomeScreen(),
  TimerScreen(),
  SettingsScreen(),
]; // Remove AddScreen
