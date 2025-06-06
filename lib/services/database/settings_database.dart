import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingDatabase {
  static final SettingDatabase _instance = SettingDatabase._internal();
  late Box<int> settingsBox;
  bool _isInitialized = false;

  // Keys for settings
  static const String themeIndexKey = 'themeIndex';
  static const String workTimeKey = 'workTime';
  static const String breakTimeKey = 'breakTime';

  // Default values
  static const int defaultThemeIndex = 0;
  static const int defaultWorkTime = 25;
  static const int defaultBreakTime = 5;

  // Private constructor
  SettingDatabase._internal();

  // Factory constructor
  factory SettingDatabase() {
    return _instance;
  }

  Future<void> initializeDatabase() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      settingsBox = await Hive.openBox<int>('settings');
      _isInitialized = true;

      // Set default values if not exist
      if (!settingsBox.containsKey(themeIndexKey)) {
        await settingsBox.put(themeIndexKey, defaultThemeIndex);
      }
      if (!settingsBox.containsKey(workTimeKey)) {
        await settingsBox.put(workTimeKey, defaultWorkTime);
      }
      if (!settingsBox.containsKey(breakTimeKey)) {
        await settingsBox.put(breakTimeKey, defaultBreakTime);
      }
    }
  }

  Future<Box<int>> get box async {
    if (!_isInitialized) {
      await initializeDatabase();
    }
    return settingsBox;
  }

  // Getters
  Future<int> getThemeIndex() async {
    final box = await this.box;
    return box.get(themeIndexKey, defaultValue: defaultThemeIndex)!;
  }

  Future<int> getWorkTime() async {
    final box = await this.box;
    return box.get(workTimeKey, defaultValue: defaultWorkTime)!;
  }

  Future<int> getBreakTime() async {
    final box = await this.box;
    return box.get(breakTimeKey, defaultValue: defaultBreakTime)!;
  }

  // Setters
  Future<void> setThemeIndex(int index) async {
    final box = await this.box;
    await box.put(themeIndexKey, index);
  }

  Future<void> setWorkTime(int minutes) async {
    final box = await this.box;
    await box.put(workTimeKey, minutes);
  }

  Future<void> setBreakTime(int minutes) async {
    final box = await this.box;
    await box.put(breakTimeKey, minutes);
  }
}