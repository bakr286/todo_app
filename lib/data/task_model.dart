import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0) String title;
  @HiveField(1) String description;
  @HiveField(2) DateTime date;
  @HiveField(3) bool isDone;
  @HiveField(4) String category;

  Task({
    this.title = '',
    this.description = '',
    DateTime? date,
    this.isDone = false,
    this.category = 'Personal',
  }) : date = date ?? DateTime(0);
}
