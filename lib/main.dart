// Only the main() function lives here.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/database.dart';
import 'package:flutter_application_1/session_1/p3.dart';
import 'package:flutter_application_1/session_1/p4.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database_helper.init();
  isDark.value = await database_helper.getDarkMode();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild the app whenever isDark changes
    return ValueListenableBuilder<bool>(
      valueListenable: isDark,
      builder: (context, dark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          home: P4(),
        );
      },
    );
  }
}
