import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data/themes.dart';

import '../services/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
            ),
            const SizedBox(height: 16),
            const ThemeSelectionGrid(),
            const SizedBox(height: 32),
            Text(
              'Other Settings',
            ),
            const SizedBox(height: 16),
            // Add more settings options here
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About'),
                  content: const Text('Todo App v1.0.0\nDeveloped by :Ahmed Abobakr'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeSelectionGrid extends StatelessWidget {
  const ThemeSelectionGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        return InkWell(
          onTap: () {
            themeProvider.setTheme(theme);
          },
          child: Container(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: themeProvider.currentTheme == theme
                    ? Colors.indigo
                    : Colors.transparent,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                theme.brightness == Brightness.light ? 'Light Theme' : 'Dark Theme',
                style: TextStyle(
                  color: theme.brightness == Brightness.light ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}