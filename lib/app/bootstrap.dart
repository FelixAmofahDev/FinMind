import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'di/injection_container.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.init();
  runApp(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(
          () => sl<AuthNotifier>(),
        ),
      ],
      child: const FinmindApp(),
    ),
  );
}