import 'package:flutter/material.dart';

import '../notifications.dart';

class TimerProvider with ChangeNotifier {
  int _workDuration = 25 * 60; 
  int _breakDuration = 5 * 60; 
  int _secondsElapsed = 0;
  bool _isWorkTime = true;
  bool _isRunning = false;

  int get workDuration => _workDuration;
  int get breakDuration => _breakDuration;
  int get secondsElapsed => _secondsElapsed;
  bool get isWorkTime => _isWorkTime;
  bool get isRunning => _isRunning;

  final NotificationService _notificationService = NotificationService();

  TimerProvider() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initializeNotification();
  }

  void setWorkDuration(int seconds) {
    _workDuration = seconds;
    notifyListeners();
  }

  void setBreakDuration(int seconds) {
    _breakDuration = seconds;
    notifyListeners();
  }

  void startTimer() {
    _isRunning = true;
    notifyListeners();
    _runTimer();
    _updatePersistentNotification();
  }

  void _runTimer() async {
    if (!_isRunning) return;

    Future.delayed(const Duration(seconds: 1), () {
      if (_secondsElapsed < (_isWorkTime ? _workDuration : _breakDuration)) {
        _secondsElapsed++;
        notifyListeners();
        _runTimer();
        _updatePersistentNotification();
      } else {
        // Timer has reached the end of the current phase
        _secondsElapsed = 0;
        _isWorkTime = !_isWorkTime;
        notifyListeners();
        _sendTimerEndNotification();
        _runTimer(); // Start the next phase
      }
    });
  }

  void pauseTimer() {
    _isRunning = false;
    notifyListeners();
    _updatePersistentNotification();
  }

  void resetTimer() {
    _isRunning = false;
    _secondsElapsed = 0;
    _isWorkTime = true;
    notifyListeners();
    _notificationService.cancelNotification(1);
  }

  void _sendTimerEndNotification() async {
    await _notificationService.showTimerEndNotification(
      title: !_isWorkTime ? 'Work Time Over' : 'Break Time Over',
      body: !_isWorkTime ? 'Time for a break!' : 'Time to work!',
    );
  }

void _updatePersistentNotification() async {
  final remainingTime = (_isWorkTime ? _workDuration : _breakDuration) - _secondsElapsed;
  await _notificationService.updatePersistentNotification(
    title: _isWorkTime ? 'Work Time' : 'Break Time',
    body: 'Time left: ${_formatDuration(remainingTime)}',
    isRunning: _isRunning,
  );
}

  void toggleTimer() {
    if (_isRunning) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
