import 'package:hive_flutter/hive_flutter.dart';
import '../data/task_model.dart';

class TodoDatabase {
  static final TodoDatabase _instance = TodoDatabase._internal();
  late Box<Task> todosBox;
  bool _isInitialized = false;

  // Private constructor
  TodoDatabase._internal();

  // Factory constructor
  factory TodoDatabase() {
    return _instance;
  }

  Future<void> initializeDatabase() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TaskAdapter());
      }
      todosBox = await Hive.openBox<Task>('todos');
      _isInitialized = true;
    }
  }

  Future<Box<Task>> get box async {
    if (!_isInitialized) {
      await initializeDatabase();
    }
    return todosBox;
  }

  Future<List<Task>> getTodos() async {
    final box = await this.box;
    return box.values.toList();
  }

  Future<void> addTodo(Task todo) async {
    final box = await this.box;
    await box.add(todo);
  }

  Future<void> updateTodo(int index, Task updatedTodo) async {
    final box = await this.box;
    await box.putAt(index, updatedTodo);
  }

  Future<void> deleteTodo(int index) async {
    final box = await this.box;
    await box.deleteAt(index);
  }
}
