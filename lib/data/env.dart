// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'DS_KEY')
  static const String dsApiKey = _Env.dsApiKey;
  // @EnviedField()
  // static const String KEY2 = _Env.KEY2;
  // @EnviedField(defaultValue: 'test_')
  // static const String key3 = _Env.key3;
}

// dart run build_runner build
