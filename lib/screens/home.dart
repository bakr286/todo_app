import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/task_model.dart';
import 'package:todo_app/services/task_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

        return Scaffold(
          appBar: AppBar(title: Text('Home'), centerTitle: true),
          body:
              tasks.isEmpty
                  ? Center(
                    child: Text('No tasks', style: TextStyle(fontSize: 20)),
                  )
                  : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      Task task = tasks[index];
                      return Dismissible(
                        key: ValueKey(index),
                        onDismissed: (direction) {
                          taskProvider.deleteTask(index);
                        },
                        child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (dialogContext) => AlertDialog(
                                    title: Text(task.title),
                                    content: Text(task.description),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(dialogContext),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          title: Text(task.title),
                          subtitle: Text(
                            task.isDone
                                ? 'Done'
                                : task.date.toString().substring(0, 16),
                            style: TextStyle(
                              color: task.isDone ? Colors.green : Colors.red,
                            ),
                          ),
                          trailing: Checkbox(
                            value: task.isDone,
                            onChanged: (value) {
                              task.isDone = value!;
                              taskProvider.updateTask(index, task);
                            },
                          ),
                        ),
                      );
                    },
                  ),
        );
      },
    );
  }
}
