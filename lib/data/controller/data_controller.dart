import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:time_manager_client/data/environment/constant.dart';
import 'package:time_manager_client/data/repository/local_storage.dart';
import 'package:time_manager_client/data/repository/remote_db.dart';
import 'package:time_manager_client/data/types/group.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/data/proto.gen/storage.pb.dart' as p;
import 'package:time_manager_client/data/types/ts_data.dart';
import 'package:time_manager_client/data/types/user_account.dart';
import 'package:time_manager_client/data/types/user.dart';
import 'package:time_manager_client/helper/extension.dart';
import 'package:time_manager_client/helper/helper.dart';

class DataController extends GetxController {
  static DataController get to => Get.find<DataController>();

  // 初始化
  DataController() {
    LocalStorage.instance?.init().then((_) {
      loadLocally();
    });
    RemoteDb.instance.init().then((_) {});
  }

  List<int> rawGroupIds = [0];
  Iterable<Group> get groups => rawGroupIds.map((e) => rawGroup[e]!);

  Map<int, Group> rawGroup = {0: Group(title: "默认分组", icon: "📢", taskIds: [], updateTimestamp: 0)};
  Map<int, Task> rawTask = {};
  User? get user => _rawUser.value;
  final _rawUser = Rx<User?>(null);

  // late final currentGroup = groups.first.obs;
  final currentGroupIndex = 0.obs;
  Group get currentGroup => rawGroup[currentGroupIndex.value]!;

  Iterable<Task> get currentGroupTasks => currentGroup.taskIds.map((e) => rawTask[e]!);

  int getGroupIndexNo() {
    if (rawGroup.keys.isEmpty) return 0;
    return rawGroup.keys.reduce((v, e) => max(v, e)) + 1;
  }

  int getTaskIndexNo() {
    if (rawTask.keys.isEmpty) return 0;
    return rawTask.keys.reduce((v, e) => max(v, e)) + 1;
  }

  void addTask(Task task, [Group? group]) {
    group ??= currentGroup;

    final index = getTaskIndexNo();
    rawTask[index] = task;
    group.taskIds.add(index);

    _onDataChanged();
  }

  void editTask(Task oldTask, Task newTask, [Group? group]) {
    group ??= currentGroup;

    int? index = rawTask.entries.where((e) => e.value == oldTask).singleOrNull?.key;
    if (index == null) {
      index = getTaskIndexNo();
      group.taskIds.add(index);
    }
    rawTask[index] = newTask;

    _onDataChanged();
  }

  void changeTaskStatus(Task task, [TaskStatus? status]) {
    status ??= task.status == TaskStatus.finished ? TaskStatus.unfinished : TaskStatus.finished;
    task.status = status;
    task.updateTimestamp();
    _onDataChanged();
  }

  Group addGroup() {
    final g = Group.title("新建分组");
    final index = getGroupIndexNo();
    rawGroup[index] = g;
    rawGroupIds.add(index);
    _onDataChanged();

    return g;
  }

  void changeGroupTitle(Group group, String title) {
    group.title = title;
    group.updateTimestamp();
    _onDataChanged();
  }

  void changeGroupIcon(Group group, String icon) {
    group.icon = icon;
    group.updateTimestamp();
    _onDataChanged();
  }

  void changeCurrentGroup(Group group) {
    // currentGroup.value = group;
    currentGroupIndex.value = rawGroup.entries.where((e) => e.value == group).single.key;
    _onDataChanged();
  }

  // QR 处理
  void handleQrCode(String code) async {
    if (code.startsWith(Constant.qrLoginPrefix)) {
      if (user == null) return;

      var token = code.substring(Constant.qrLoginPrefix.length);
      var r = await RemoteDb.instance.verifyQrLoginToken(token, user!.id);
      if (r) Get.snackbar("🎉验证成功", "请前往桌面端/Web端查看");
      // print("qr code: $token");
    }
  }

  // 数据写入
  void _onDataChanged([_DataChangeType t = _DataChangeType.groupOrTask]) {
    switch (t) {
      case _DataChangeType.groupOrTask:
        update();
        break;
      case _DataChangeType.user:
        update([User.getControllerId]);
        break;
    }
    LocalStorage.instance?.write(toProto(true));
  }

  // 导出
  p.Storage toProto([bool needUserInfo = false]) => p.Storage(
        groups: rawGroup.map((k, v) => MapEntry(k.toInt64(), v.toProto())),
        tasks: rawTask.map((k, v) => MapEntry(k.toInt64(), v.toProto())),
        groupIds: rawGroupIds.map((e) => e.toInt64()),
        currentGroupId: currentGroupIndex.value.toInt64(),
        user: Helper.if_(needUserInfo, user?.toProto()),
      );

  Future<File?> saveDownloadDirectory() => LocalStorage.instance?.writeToDownloadDirectory(toProto()) ?? Future.value(null);

  String saveAsText() => Base64Encoder().convert(toProto().writeToBuffer());

  // 导入
  void loadLocally() {
    loadData(null);
    // if (!loadData(null)) throw Exception("LocalStorage is not available");
  }

  bool loadData(Uint8List? data) {
    // data 非空 则从外部导入
    try {
      final r = LocalStorage.instance?.read(data);
      if (r == null) return false;
      rawGroup = r.groups;
      rawTask = r.tasks;
      rawGroupIds = r.groupIds;
      currentGroupIndex.value = r.currentGroup; // todo
      update();
      if (data != null) {
        // 外部导入 -> 保存
        LocalStorage.instance?.write(toProto());
      } else {
        // 本地存储(内部导入) -> 加载用户信息
        _rawUser.value = r.user;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  bool loadFromText(String text) {
    final d = Base64Decoder().convert(text);
    return loadData(d);
  }

  // 数据库

  // 登陆
  Future<bool> loginWithPhoneNumber(int phone) async {
    int? i = await RemoteDb.instance.signInWithPhoneNumber(phone);
    i ??= await RemoteDb.instance.signUpWithPhoneNumber(phone);
    // print(i);
    _rawUser.value = User(
      id: i,
      accounts: [UserAccountPhone(phone)],
    );

    // _onDataChanged(_DataChangeType.user);
    getUserInfo();
    return true;
  }

  // Qr 验证
  Future<bool> loginWithQr(String token) async {
    final i = await RemoteDb.instance.listenQrLoginUser(token);
    if (i != null) {
      _rawUser.value = User(id: i);
      _onDataChanged(_DataChangeType.user);
      getUserInfo();
      return true;
    } else {
      return false;
    }
  }

  // 登出
  void logout() {
    _rawUser.value = null;
    _onDataChanged(_DataChangeType.user);
  }

  // 获取用户账号
  void getUserInfo() async {
    if (user == null) return;
    final r = await RemoteDb.instance.getUserAccounts(user!.id);
    _rawUser.update((u) {
      u?.accounts = r;
    });
    _onDataChanged(_DataChangeType.user);
  }

  // 数据同步
  // 全量同步
  // Task
  // Future<void> syncTask() async {
  //   if (user == null) return;

  //   // 1. 数据新旧比较
  //   Set<int> cloudNewIds = {}; // 数据库数据新  -> 更新本地
  //   Set<int> localNewIds = {}; // 本地数据新    -> 上数据库

  //   // 1.1 云端数据
  //   final tt = await RemoteDb.instance.getTaskWithTime(user!.id);
  //   for (final (id, updateAt) in tt) {
  //     if (!rawTask.containsKey(id) || rawTask[id]!.updateTimestampAt < updateAt) {
  //       cloudNewIds.add(id);
  //     } else {
  //       localNewIds.add(id);
  //     }
  //   }
  //   // 1.2 本地数据
  //   for (final i in rawTask.keys) {
  //     if (!cloudNewIds.contains(i)) {
  //       localNewIds.add(i);
  //     }
  //   }

  //   print("ddd cloud: $cloudNewIds");
  //   print("ddd local: $localNewIds");

  //   // 2. 更新本地数据
  //   final it = await RemoteDb.instance.getTask(user!.id, cloudNewIds.toList());
  //   rawTask.cover(it);

  //   // 3. 更新数据库数据
  //   await RemoteDb.instance.updateTask(user!.id, {for (var i in localNewIds) i: rawTask[i]!});

  //   _onDataChanged();
  // }

  Future<void> syncAll() async {
    await syncData<Group>();
    await syncData<Task>();
    _onDataChanged();
  }

  Future<void> syncData<T extends TsData>() async {
    if (user == null) return;

    // 1. 数据新旧比较
    Set<int> cloudNewIds = {}; // 数据库数据新  -> 更新本地
    Set<int> localNewIds = {}; // 本地数据新    -> 上数据库
    final rawMap = _getRaw<T>();

    // 1.1 云端数据
    final tt = await RemoteDb.instance.getWithTime<T>(user!.id);
    for (final (id, updateAt) in tt) {
      if (!rawMap.containsKey(id) || rawMap[id]!.updateTimestampAt < updateAt) {
        cloudNewIds.add(id);
      } else {
        localNewIds.add(id);
      }
    }
    // 1.2 本地数据
    for (final i in rawMap.keys) {
      if (!cloudNewIds.contains(i)) {
        localNewIds.add(i);
      }
    }

    print("ddd cloud: $cloudNewIds");
    print("ddd local: $localNewIds");

    // 2. 更新本地数据
    final it = await RemoteDb.instance.getData<T>(user!.id, cloudNewIds.toList());
    rawMap.cover(it);

    // 3. 更新数据库数据
    await RemoteDb.instance.update<T>(user!.id, {for (var i in localNewIds) i: rawMap[i]!});
  }

  Map<int, T> _getRaw<T extends TsData>() {
    print(T.runtimeType);
    print("ddd ty: ${T}");

    if (T == Task) return rawTask as Map<int, T>;
    if (T == Group) return rawGroup as Map<int, T>;
    throw Exception("Unknown type");

    // (T _).;
    // switch (T.runtimeType) {
    //   case Task _:
    //     return rawTask as Map<int, T>;
    //   case Group _:
    //     return rawGroup as Map<int, T>;
    //   default:
    //     throw Exception("Unknown type");
    // }
  }
}

enum _DataChangeType {
  groupOrTask,
  user,
}
