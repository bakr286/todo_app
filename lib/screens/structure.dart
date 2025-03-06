import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../data/task_model.dart';
import '../services/providers/task_provider.dart';
import '../services/providers/theme_provider.dart';
import '../services/providers/timer_provider.dart';
import 'add.dart';
import 'home.dart';
import 'timer.dart';

class Structure extends StatefulWidget {
  const Structure({super.key});

  @override
  State<Structure> createState() => _StructureState();
}

int index = 0;
var taskProvider = TaskProvider();
var timerProvider = TimerProvider();
var themeProvider= ThemeProvider();

class _StructureState extends State<Structure> {
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
              buttonIcon = timerProvider.isRunning ? Icons.pause : Icons.play_arrow_sharp;
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
                  setState(() {
                    index = 1;
                  });
                  break;
                case 1:
                  final addScreen = screens[1] as AddScreen;
                  if (addScreen.formKey.currentState?.validate() ?? false) {
                    addScreen.formKey.currentState?.save();
                    final task = Task(
                      title: addScreen.task.title,
                      description: addScreen.task.description,
                      date: addScreen.task.date,
                      isDone: false,
                      category: addScreen.task.category,
                    );
                    await taskProvider.addTask(task);
                    addScreen.resetTask();
                    setState(() => index = 0);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all fields'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  break;
                case 2:
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
          GButton(icon: Icons.add, backgroundColor: Colors.red),
          GButton(icon: Icons.timer, text: 'Timer'),
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

List screens = [HomeScreen(), AddScreen(), TimerScreen()];
