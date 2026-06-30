import 'package:finmind/app/config/app_constants.dart';
import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'router/routes.dart';
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
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}