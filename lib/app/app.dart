import 'package:flutter/material.dart';

import 'config/app_constants.dart';
import 'router/app_router.dart';
import '../core/theme/app_theme.dart';

class FinmindApp extends StatelessWidget {
  const FinmindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AppConfig.initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}