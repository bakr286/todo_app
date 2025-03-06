import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/task_model.dart';
import 'package:todo_app/services/providers/task_provider.dart';

import '../widgets/task_widget.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0; // Track selected filter index

  @override
  void initState() {
    super.initState();
    // Load tasks when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tasks;
        var personalTasks = tasks.where((task) => task.category == 'Personal').toList();
        var workTasks = tasks.where((task) => task.category == 'Work').toList();
        var academicTasks = tasks.where((task) => task.category == 'Academic').toList();
        Map<String, List<Task>> taskList = {
          'All': tasks,
          'Personal': personalTasks,
          'Work': workTasks,
          'Academic': academicTasks,
        };

        // Get the currently selected task list based on the selected index
        final currentTasks = taskList.values.elementAt(selectedIndex);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.settings),onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },),
          ),
          body: tasks.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : Column(
                  children: [
                    // Horizontal filter buttons
                    SizedBox(
                      height: 50, // Constrain the height
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: taskList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedIndex == index
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              child: Text(
                                taskList.keys.elementAt(index),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Vertical task list
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentTasks.length,
                        itemBuilder: (context, index) {
                          final task = currentTasks[index];
                          return Dismissible(
                            key: Key(task.hashCode.toString()),
                            onDismissed: (_) async {
                              await taskProvider.deleteTask(index);
                            },
                            child: TaskBuild(task: task, index: index),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}