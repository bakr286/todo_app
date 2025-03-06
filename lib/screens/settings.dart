import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data/themes.dart';

import '../services/providers/theme_provider.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
        ),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          return ListTile(
            
            tileColor: themes[index].primaryColor,
            title: Text(
              themes[index].brightness == Brightness.light
                  ? 'Light Theme'
                  : 'Dark Theme',
            ),
            onTap: () {
              themeProvider.setTheme(themes[index]);
            },
          );
        },
      ),
    );
  }
}