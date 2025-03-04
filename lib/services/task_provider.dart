import 'package:flutter/material.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/services/notifications.dart';

import '../data/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final TodoDatabase _db = TodoDatabase();
  final NotificationService _notificationService = NotificationService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await _db.getTodos();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _db.addTodo(task);
    await _notificationService.scheduleNotification(task);
    await loadTasks();
    notifyListeners();
  }

  Future<void> updateTask(int index, Task task) async {
    await _db.updateTodo(index, task);
    await _notificationService.cancelNotification(task.hashCode);
    if (!task.isDone) {
      await _notificationService.scheduleNotification(task);
    }
    await loadTasks();
    notifyListeners();
  }

  Future<void> deleteTask(int index) async {
    await _db.deleteTodo(index);
    final task = _tasks[index];
    await _notificationService.cancelNotification(task.hashCode);
    await loadTasks();
    notifyListeners();
  }
}
