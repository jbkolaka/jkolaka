import 'package:flutter/material.dart';

import 'feature/project/presentation/project_page.dart';
import 'feature/work/widget/circle_pointer.dart';
import 'theme/app_theme.dart';
import 'widgets/portfolio_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      builder: (context, child) => CirclePointer(child: child!),
      routes: {
        '/project': (context) => const ProjectPage(),
      },
      home: const PortfolioShell(),
    );
  }
}