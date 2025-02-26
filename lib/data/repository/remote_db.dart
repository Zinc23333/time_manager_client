import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_manager_client/data/environment/env.dart';
import 'package:time_manager_client/data/repository/logger.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/data/types/ts_data.dart';
import 'package:time_manager_client/data/types/user_account.dart';
import 'package:time_manager_client/data/types/web_crawler_web.dart';

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
    final pl = await _supa.from("user_info_phone").select("phone").eq("userId", userId);
    final wl = await _supa.from("user_info_wechat").select("openid").eq("userId", userId);
    return [
      ...pl.map((e) => UserAccountPhone(e["phone"])),
      ...wl.map((e) => UserAccountWechatOpenId(e["openid"])),
    ];
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

  // 更新数据库 单条数据 task/group
  // param tasks: 需要更新的tasks
  Future<void> updateOne<T extends TsData>(int userId, (int, T) it) async {
    await _supa.from(it.$2.tableName).upsert({
      "userId": userId,
      "id": it.$1,
      "updateAt": it.$2.updateTimestampAt,
      // if (!it.$2.isDeleted )
      "data": it.$2.isDeleted ? null : it.$2.toMap(),
    }, onConflict: "userId, id");
  }

  // 监听数据库数据变化
  Stream<(int, int, T?)> listenDataChange<T extends TsData>(int userId) => _supa
      .from(TsData.getTableName<T>())
      .stream(primaryKey: ["id, userId"])
      .eq("userId", userId)
      .map((lm) => lm.map((m) => (
            m["id"] as int,
            m["updateAt"] as int,
            TsData.fromMapNullable<T>(m["data"]),
          )))
      .expand((ld) => ld)
      .handleError((e) => logger.d(e));

  // 获取用户Prompt
  Future<String?> getUserPrompt(int userId) async {
    final d = await _supa.from("user_prompts").select("prompt").eq("userId", userId).maybeSingle();
    return d?["prompt"];
  }

  // 更新用户Prompt
  Future<void> updateUserPrompt(int userId, String prompts) async {
    await _supa.from("user_prompts").upsert({"userId": userId, "prompt": prompts}, onConflict: "userId");
  }

  // 网页爬虫逻辑
  Future<List<WebCrawlerWeb>> getWebCrawlerWebs() async {
    final d = await _supa.from("crawler_web").select("id, name, summary, lastCrawl").eq("verify", true);
    return d.map((l) => WebCrawlerWeb.fromMap(l)).toList();
  }

  // 网页爬虫: 某一网页任务
  Future<List<Task>> getWebCrawlerTasks(int webId) async {
    final d = await _supa.from("crawler_tasks").select("tasks").eq("webId", webId);
    // d as List<Map<String, dynamic>>;
    // d => [{tasks: [{}, {}]}]
    // final t = d.map((l) => (l["tasks"] as List)).cast<Map<String, dynamic>>().expand((l) => l);
    final t = [
      for (final l in d)
        for (final t in (l["tasks"] as List)) Task.fromMap(t)
    ];
    // .expand((l) => l).map((t) => Task.fromMap(t)).toList();
    logger.t(t);
    return t;
  }

  // 网页爬虫: 提交
  Future<void> submitWebCrawler(String name, String summary, String code, int? userId) async {
    code = code.split("\n").where((l) => l.trim().isNotEmpty && !l.trimLeft().startsWith("#")).map((l) => l.trimRight()).join("\n");
    await _supa.from("crawler_web").insert({"name": name, "summary": summary, "pythonCode": code, "userId": userId});
  }
}
