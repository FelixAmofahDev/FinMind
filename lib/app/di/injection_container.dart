import '../config/env.dart';

class InjectionContainer {
  const InjectionContainer._();

  static Future<void> init() async {
    AppEnv.current;
  }
}