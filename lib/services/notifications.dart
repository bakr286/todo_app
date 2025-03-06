import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../data/task_model.dart'; // Ensure this import is present for Task model

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();


  Future<void> initializeNotification() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Request permissions
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  Future<void> showTimerEndNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'timer_channel',
      'Timer Notifications',
      channelDescription: 'Notifications for timer events',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> showPersistentNotification({
    required String title,
    required String body,
    required bool isRunning,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'persistent_timer_channel',
      'Persistent Timer Notifications',
      channelDescription: 'Notifications for persistent timer updates',
      importance: Importance.low, // Use low importance to avoid alerts
      priority: Priority.low,
      ongoing: true, // Keep the notification persistent
      showWhen: false,
      onlyAlertOnce: true, // Ensure the notification only alerts once
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Use a fixed notification ID (e.g., 1) to create the persistent notification
    await flutterLocalNotificationsPlugin.show(
      1, // Fixed ID for the persistent notification
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> updatePersistentNotification({
    required String title,
    required String body,
    required bool isRunning,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'persistent_timer_channel',
      'Persistent Timer Notifications',
      channelDescription: 'Notifications for persistent timer updates',
      importance: Importance.low, // Use low importance to avoid alerts
      priority: Priority.low,
      ongoing: true, // Keep the notification persistent
      showWhen: false,
      onlyAlertOnce: true, // Ensure the notification only alerts once
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Update the existing notification with the same ID
    await flutterLocalNotificationsPlugin.show(
      1, // Same ID as the initial notification
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> scheduleNotification(Task task) async {
    if (task.date.isBefore(DateTime.now())) return;

    final scheduledTime = tz.TZDateTime.from(task.date, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.hashCode,
      'Todo Reminder',
      task.title,
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_channel',
          'Todo Notifications',
          channelDescription: 'Notifications for todo tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}