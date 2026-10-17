// QUESTION (Task 3):
// Build a settings toggle like Instagram's 'Dark Mode' switch - store the
// user's theme preference locally so that when the app is closed and reopened
// (simulate by hot restart), the selected theme is remembered and applied.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/database.dart';

final isDark = ValueNotifier<bool>(false);

class P3 extends StatelessWidget {
  const P3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ValueListenableBuilder<bool>(
        valueListenable: isDark,
        builder: (context, dark, child) {
          return SwitchListTile(
            title: const Text('Dark Mode'),
            value: dark,
            onChanged: (value) async {
              isDark.value = value;
              await database_helper.saveDarkMode(value);
            },
          );
        },
      ),
    );
  }
}
