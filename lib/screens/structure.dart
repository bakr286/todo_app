import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../data/task_model.dart';
import '../services/task_provider.dart';
import 'add.dart';
import 'home.dart';
import 'timer.dart';

class Structure extends StatefulWidget {
  const Structure({super.key});

  @override
  State<Structure> createState() => _StructureState();
}

int index = 0;
var tp = TaskProvider();

class _StructureState extends State<Structure> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, tp, child) {
        IconData? buttonIcon =
            index == 0
                ? Icons.add
                : index == 1
                ? Icons.check
                : Icons.access_time_rounded;
        return Scaffold(
          floatingActionButton: FloatingActionButton(
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
                      isDone: false
                    );
                    await tp.addTask(task);
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
                  break;
                default:
              }
            },
            child: Icon(buttonIcon),
          ),
          body: screens[index],
          bottomNavigationBar: GNav(
            tabBackgroundColor: Theme.of(context).colorScheme.secondary,
            tabs: [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.add),
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
      },
    );
  }
}

List screens = [HomeScreen(), AddScreen(), TimerScreen()];
