import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'DS_KEY')
  static const String dsApiKey = _Env.dsApiKey;

  @EnviedField(varName: 'SUPA_URL')
  static const String supaUrl = _Env.supaUrl;

  @EnviedField(varName: 'SUPA_ANON')
  static const String supaAnon = _Env.supaAnon;
}

// dart run build_runner build
