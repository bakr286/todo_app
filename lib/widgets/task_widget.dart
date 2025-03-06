import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/task_model.dart';
import '../services/providers/task_provider.dart';

class TaskBuild extends StatefulWidget {
  const TaskBuild({super.key, required this.task, required this.index});
  final int index;
  final Task task;

  @override
  State<TaskBuild> createState() => _TaskBuildState();
}

class _TaskBuildState extends State<TaskBuild> {
  // Helper function to get the relative date string with time
  String _getRelativeDateWithTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final taskDate = DateTime(date.year, date.month, date.day);

    // Format the time as "hh:mm a" (e.g., 12:00 PM)
    final time = DateFormat('hh:mm a').format(date);

    if (taskDate == today) {
      return 'Today $time';
    } else if (taskDate == yesterday) {
      return 'Yesterday $time';
    } else if (taskDate == tomorrow) {
      return 'Tomorrow $time';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} $time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              widget.task.category == 'Personal'
                  ? Colors.blue
                  : widget.task.category == 'Work'
                  ? Colors.red
                  : widget.task.category == 'Academic'
                  ? Colors.green
                  : Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (dialogContext) => AlertDialog(
                  title: Text(widget.task.title),
                  content: Text(widget.task.description),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Close'),
                    ),
                  ],
                ),
          );
        },
        title: Text(widget.task.title),

        trailing: Text(
          widget.task.isDone
              ? 'Done'
              : widget.task.date == DateTime(0)
              ? 'No Reminder'
              : _getRelativeDateWithTime(widget.task.date),
          style: TextStyle(
            color:
                widget.task.isDone
                    ? Colors.green
                    : widget.task.date.isBefore(DateTime.now()) &&
                        widget.task.date != DateTime(0)
                    ? Colors.red
                    : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
        leading: Checkbox(
          value: widget.task.isDone,
          onChanged: (value) {
            setState(() {
              widget.task.isDone = value!;
              TaskProvider().updateTask(widget.index, widget.task);
            });
          },
        ),
      ),
    );
  }
}
