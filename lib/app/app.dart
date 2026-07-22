import 'package:finmind/app/config/app_constants.dart';
import 'package:finmind/core/providers/core_providers.dart';
import 'package:finmind/shared/widgets/session_expired_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'router/routes.dart';
import '../core/theme/app_theme.dart';

class FinmindApp extends ConsumerStatefulWidget {
  const FinmindApp({super.key});

  @override
  ConsumerState<FinmindApp> createState() => _FinmindAppState();
}

class _FinmindAppState extends ConsumerState<FinmindApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    final authService = ref.read(authServiceProvider);
    authService.onAuthFailure.listen((_) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        SessionExpiredDialog.show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      //darkTheme: AppTheme.dark(),
      //themeMode: ThemeMode.system,
      navigatorKey: navigatorKey,
      initialRoute: AppRoutes.authGate,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}