import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_manager_client/data/environment/env.dart';

class RemoteDb {
  RemoteDb._();
  static final RemoteDb _instance = RemoteDb._();
  static RemoteDb get instance => _instance;

  late SupabaseClient supabase;

  Future<void> init() async {
    await Supabase.initialize(
      url: Env.supaUrl,
      anonKey: Env.supaAnon,
    );

    supabase = Supabase.instance.client;
  }

  // 登录
  // 返回: userId
  Future<int?> signInWithPhoneNumber(int phone) async {
    final d = await supabase.from("user_info_phone").select("userId").eq("phone", phone);
    return d.singleOrNull?["userId"];
  }

  // 注册
  Future<int> signUpWithPhoneNumber(int phone) async {
    final d = await supabase.from("users").insert({}).select("id");
    int i = d.single["id"];
    await supabase.from("user_info_phone").insert({"userId": i, "phone": phone});

    return i;
  }
}
