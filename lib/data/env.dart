import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'DS_KEY')
  static const String dsApiKey = _Env.dsApiKey;
}

// dart run build_runner build
