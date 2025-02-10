import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_manager_client/data/environment/env.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/data/types/ts_data.dart';
import 'package:time_manager_client/data/types/user_account.dart';

class RemoteDb {
  RemoteDb._();
  static final RemoteDb _instance = RemoteDb._();
  static RemoteDb get instance => _instance;

  late SupabaseClient _supa;

  Future<void> init() async {
    await Supabase.initialize(
      url: Env.supaUrl,
      anonKey: Env.supaAnon,
    );

    _supa = Supabase.instance.client;
  }

  // 登录
  // 返回: userId
  Future<int?> signInWithPhoneNumber(int phone) async {
    final d = await _supa.from("user_info_phone").select("userId").eq("phone", phone);
    return d.singleOrNull?["userId"];
  }

  // 注册
  Future<int> signUpWithPhoneNumber(int phone) async {
    final d = await _supa.from("users").insert({}).select("id");
    int i = d.single["id"];
    await _supa.from("user_info_phone").insert({"userId": i, "phone": phone});

    return i;
  }

  // Qr登陆请求 (step1:桌面端)
  Future<String?> requestQrLoginToken() async {
    final d = await _supa.from("qr_login_request").insert({}).select("token, requestAt");
    String? token = d.singleOrNull?["token"];
    return token;
  }

  // Qr登陆验证 (step2:移动端)
  Future<bool> verifyQrLoginToken(String token, int userId) async {
    final now = DateTime.now().toUtc();
    final d = await _supa.from("qr_login_request").select("id, requestAt").eq("token", token);
    if (d.isEmpty) return false;
    if (now.difference(DateTime.parse(d.first["requestAt"])).inMinutes > 30) return false;
    await _supa.from("qr_login_request").update({"userId": userId}).eq("id", d.first["id"]);

    return true;
  }

  // Qr监听验证 (step3:桌面端)
  Future<int?> listenQrLoginUser(String token) async {
    final s = _supa.from("qr_login_request").stream(primaryKey: ["id"]).eq("token", token).timeout(Duration(minutes: 25));
    await for (var e in s) {
      for (final l in e) {
        if (l["userId"] != null) {
          return l["userId"];
        }
      }
    }
    return null;
  }

  // 获取用户账号
  Future<List<UserAccount>> getUserAccounts(int userId) async {
    final d = await _supa.from("user_info_phone").select("phone").eq("userId", userId);
    return d.map((e) => UserAccountPhone(e["phone"])).toList();
  }

  // 获取数据库的 task (id, updateAt)
  Future<Iterable<(int id, int updateAt)>> getTaskWithTime(int userId) async {
    final d = await _supa.from("tasks").select("id, updateAt").eq("userId", userId);
    return d.map((e) => (e["id"] as int, e["updateAt"] as int));
  }

  // 获取数据库给定 ids 的 task
  Future<Map<int, Task?>> getTask(int userId, List<int> ids) async {
    final d = await _supa.from("tasks").select("id, data").eq("userId", userId).inFilter("id", ids);
    return {for (final m in d) m["id"]: Task.fromMapNullable(m["data"])};
  }

  // 更新数据库 task
  // param tasks: 需要更新的tasks
  Future<void> updateTask(int userId, Map<int, Task> tasks) async {
    await _supa.from("tasks").upsert(
        tasks.entries
            .map((e) => {
                  "userId": userId,
                  "id": e.key,
                  "updateAt": e.value.updateTimestampAt,
                  "data": e.value.toMap(),
                })
            .toList(),
        onConflict: "userId, id");
  }

  // 获取数据库的 task/group (id, updateAt)
  Future<Iterable<(int id, int updateAt)>> getWithTime<T>(int userId) async {
    final d = await _supa.from(TsData.getTableName<T>()).select("id, updateAt").eq("userId", userId);
    return d.map((e) => (e["id"] as int, e["updateAt"] as int));
  }

  // 获取数据库给定 ids 的 task/group
  Future<Map<int, T?>> getData<T>(int userId, List<int> ids) async {
    final d = await _supa.from(TsData.getTableName<T>()).select("id, data").eq("userId", userId).inFilter("id", ids);
    return {for (final m in d) m["id"]: TsData.fromMapNullable<T>(m["data"])};
  }

  // 更新数据库 task/group
  // param tasks: 需要更新的tasks
  Future<void> update<T extends TsData>(int userId, Map<int, T> ts) async {
    await _supa.from(TsData.getTableName<T>()).upsert(
        ts.entries
            .map((e) => {
                  "userId": userId,
                  "id": e.key,
                  "updateAt": e.value.updateTimestampAt,
                  "data": e.value.toMap(),
                })
            .toList(),
        onConflict: "userId, id");
  }
}
