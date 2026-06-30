import 'package:flutter/widgets.dart';

import 'app.dart';
import 'di/injection_container.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.init();
  runApp(const FinmindApp());
}