import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:todo_app/screens/structure.dart';

import '../services/providers/timer_provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();

  void timerFunction() {
    timerProvider.isRunning
        ? timerProvider.pauseTimer
        : timerProvider.startTimer;
  }
}

class _TimerScreenState extends State<TimerScreen> {
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    return '$minutes minutes';
  }

  Future<void> _showCustomTimePickerDialog(
    BuildContext context,
    bool isWorkTime,
  ) async {
    TextEditingController hoursController = TextEditingController(
      text:
          (isWorkTime
                  ? context.read<TimerProvider>().workDuration ~/ 3600
                  : context.read<TimerProvider>().breakDuration ~/ 3600)
              .toString(),
    );
    TextEditingController minutesController = TextEditingController(
      text:
          ((isWorkTime
                      ? context.read<TimerProvider>().workDuration ~/ 60
                      : context.read<TimerProvider>().breakDuration ~/ 60) %
                  60)
              .toString(),
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(isWorkTime ? 'Set Work Time' : 'Set Break Time'),
          ),
          content: Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: hoursController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Hours',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: minutesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Minutes',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final hours = int.tryParse(hoursController.text) ?? 0;
                final minutes = int.tryParse(minutesController.text) ?? 0;
                final selectedDuration = Duration(
                  hours: hours,
                  minutes: minutes,
                );
                if (isWorkTime) {
                  context.read<TimerProvider>().setWorkDuration(
                    selectedDuration.inSeconds,
                  );
                } else {
                  context.read<TimerProvider>().setBreakDuration(
                    selectedDuration.inSeconds,
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Timer'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timerProvider.isWorkTime ? 'Work Time' : 'Break Time',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SleekCircularSlider(
              min: 0,
              max:
                  (timerProvider.isWorkTime
                          ? timerProvider.workDuration
                          : timerProvider.breakDuration)
                      .toDouble(),
              initialValue: timerProvider.secondsElapsed.toDouble(),
              appearance: CircularSliderAppearance(
                size: 200,
                startAngle: 270,
                angleRange: 360,
                customWidths: CustomSliderWidths(
                  progressBarWidth: 10,
                  trackWidth: 10,
                ),
                customColors: CustomSliderColors(
                  trackColor:
                      timerProvider.isWorkTime ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.secondary,
                  progressBarColor: Colors.grey[300]!,
                  dotColor:
                      timerProvider.isWorkTime ? Theme.of(context).primaryColor : Theme.of(context).secondaryHeaderColor,
                ),
                infoProperties: InfoProperties(
                  mainLabelStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  modifier: (double seconds) {
                    final hours = seconds ~/ 3600; // Get total hours
                    final minutes =
                        (seconds % 3600) ~/ 60; // Get remaining minutes
                    final remainingSeconds =
                        seconds % 60; // Get remaining seconds

                    // Format hours, minutes, and seconds with leading zeros
                    final hoursStr = hours.toString().padLeft(2, '0');
                    final minutesStr = minutes.toString().padLeft(2, '0');
                    final secondsStr = remainingSeconds
                        .toInt()
                        .toString()
                        .padLeft(2, '0');

                    return '$hoursStr:$minutesStr:$secondsStr';
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: timerProvider.resetTimer,
              child: const Text('Reset'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _showCustomTimePickerDialog(context, true),
                  child: const Text('Work Time'),
                ),
                const SizedBox(width: 10),
                Text(_formatDuration(timerProvider.workDuration)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _showCustomTimePickerDialog(context, false),
                  child: const Text('Break Time'),
                ),
                const SizedBox(width: 10),
                Text(_formatDuration(timerProvider.breakDuration)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
