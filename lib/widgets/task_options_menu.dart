import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/task_model.dart';
import '../screens/add_edit_task_screen.dart';
import '../services/providers/task_provider.dart';

class TaskOptionsMenu {
  static void showOptions(BuildContext context, Task task, int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset offset = renderBox.localToGlobal(Offset.zero);

      showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(
          offset.dx + renderBox.size.width,
          offset.dy,
          offset.dx,
          offset.dy + renderBox.size.height,
        ),
        items: [
          PopupMenuItem(
            value: 'Details',
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blueGrey),
                SizedBox(width: 8),
                Text('Details'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Edit',
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.blue),
                SizedBox(width: 8),
                Text('Edit'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete'),
              ],
            ),
          ),
        ],
      ).then((selectedOption) {
        if (selectedOption != null) {
          switch (selectedOption) {
            case 'Details':
              _showDetails(context, task);
              break;
            case 'Edit':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AddEditTaskScreen(task: task, index: index),
                ),
              );
              break;
            case 'Delete':
              Provider.of<TaskProvider>(
                context,
                listen: false,
              ).deleteTask(index);
              break;
          }
        }
      });
    });
  }

  static void _showDetails(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task.title),
          content: Text(task.description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
