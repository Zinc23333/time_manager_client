import 'dart:async';
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
    RemoteDb.instance.init().then((_) {
      syncAll().then((_) {
        startSync();
      });
    });
  }

  Iterable<Group> get groups => rawGroup.values;
  Iterable<Task> get tasks => rawTask.values;
  User? get user => _rawUser.value;

  // List<int> rawGroupIds = [0];
  Map<int, Group> rawGroup = {0: Group(title: "默认分组", icon: "📢", taskIds: [], updateTimestamp: 0)};
  Map<int, Task> rawTask = {};
  final _rawUser = Rx<User?>(null);

  // 数据同步->本地更新后 需要提交的数据
  // final List<(int id, TsData data)> _needSubbmit = [];
  StreamController<(int id, TsData data)> _needSubbmitDataController = StreamController();
  StreamController<(int, int, Task?)> _taskStreamController = StreamController();
  StreamController<(int, int, Group?)> _groupStreamController = StreamController();

  final syncing = true.obs;

  // late final currentGroup = groups.first.obs;
  final currentGroupIndex = 0.obs;
  Group get currentGroup {
    if (rawGroup.containsKey(currentGroupIndex.value)) {
      return rawGroup[currentGroupIndex.value]!;
    } else {
      currentGroupIndex.value = rawGroup.keys.first;
      return rawGroup[currentGroupIndex.value]!;
    }
  }

  Iterable<Task> get currentGroupTasks => currentGroup.taskIds.map((e) => rawTask[e] ?? Task.loading());

  final _rawRadom = Random();
  int getRawNewIndexNo<T extends TsData>() {
    final r = _getRaw<T>();

    int k = 0;
    for (int i = 0; i < 100; i++) {
      k = _rawRadom.nextInt(2147483647);
      if (!r.containsKey(k)) break;
    }
    return k;
  }

  int getRawIndexNo<T extends TsData>(T d) => _getRaw<T>().entries.where((e) => e.value == d).single.key;

  // 添加任务
  void addTask(Task task, [Group? group]) {
    group ??= currentGroup;

    final index = getRawNewIndexNo<Task>();
    rawTask[index] = task;
    group.taskIds.add(index);
    group.updateTimestamp();

    final groupId = getRawIndexNo(group);
    _needSubbmitDataController.add((index, task));
    _needSubbmitDataController.add((groupId, group));

    _onDataChanged();
  }

  // 编辑任务
  // param: oldTask: 需要被替换的任务 (不一定存在rawTask中)
  // param: newTask: 替换的任务
  void editTask(Task oldTask, Task newTask, [Group? group]) {
    group ??= currentGroup;

    int? index = rawTask.entries.where((e) => e.value == oldTask).singleOrNull?.key;
    if (index == null) {
      // 不存在rawTask中  -> 新建任务
      index = getRawNewIndexNo<Task>();
      group.taskIds.add(index);
      group.updateTimestamp();

      _needSubbmitDataController.add((getRawIndexNo(group), group));
    }

    rawTask[index] = newTask;
    _needSubbmitDataController.add((index, newTask));

    _onDataChanged();
  }

  // 修改任务状态
  void changeTaskStatus(Task task, [TaskStatus? status]) {
    status ??= task.status == TaskStatus.finished ? TaskStatus.unfinished : TaskStatus.finished;
    task.status = status;
    task.updateTimestamp();

    _needSubbmitDataController.add((getRawIndexNo(task), task));

    _onDataChanged();
  }

  // 删除任务
  void deleteTask(Task task, [Group? group]) {
    group ??= currentGroup;

    final gId = getRawIndexNo(group);
    final tId = getRawIndexNo(task);

    rawTask.remove(tId);
    rawGroup[gId]!.taskIds.remove(tId);

    _needSubbmitDataController.add((gId, group));
    _needSubbmitDataController.add((tId, Task.delete()));

    _onDataChanged();
  }

  // 添加组
  Group addGroup() {
    final g = Group.title("新建分组");
    final index = getRawNewIndexNo<Group>();
    rawGroup[index] = g;
    // rawGroupIds.add(index);

    _needSubbmitDataController.add((index, g));

    _onDataChanged();
    return g;
  }

  // 修改组标题
  void changeGroupTitle(Group group, String title) {
    group.title = title;
    group.updateTimestamp();

    _needSubbmitDataController.add((getRawIndexNo(group), group));

    _onDataChanged();
  }

  // 修改组图标
  void changeGroupIcon(Group group, String icon) {
    group.icon = icon;
    group.updateTimestamp();

    _needSubbmitDataController.add((getRawIndexNo(group), group));

    _onDataChanged();
  }

  // 删除组
  void deleteGroup(Group group) {
    for (final tId in group.taskIds) {
      rawTask.remove(tId);
      _needSubbmitDataController.add((tId, Task.delete()));
    }

    final gId = getRawIndexNo(group);
    print(gId);
    print(group);
    print(rawGroup);
    rawGroup.remove(gId);
    _needSubbmitDataController.add((gId, Group.delete()));
    currentGroupIndex.value = 0;

    _onDataChanged();
  }

  // 修改当前组
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
    final ids = switch (t) {
      _DataChangeType.groupOrTask => null,
      _DataChangeType.user => [User.getControllerId],
    };
    update(ids);
    LocalStorage.instance?.write(toProto(true));
  }

  // 导出
  p.Storage toProto([bool needUserInfo = false]) => p.Storage(
        groups: rawGroup.map((k, v) => MapEntry(k.toInt64(), v.toProto())),
        tasks: rawTask.map((k, v) => MapEntry(k.toInt64(), v.toProto())),
        // groupIds: rawGroupIds.map((e) => e.toInt64()),
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
      // rawGroupIds = r.groupIds;
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

    afterLogin();
    return true;
  }

  // Qr 验证
  Future<bool> loginWithQr(String token) async {
    final i = await RemoteDb.instance.listenQrLoginUser(token);
    if (i != null) {
      _rawUser.value = User(id: i);
      afterLogin();
      return true;
    } else {
      return false;
    }
  }

  void afterLogin() async {
    await syncAll();
    startSync();
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

  void startSync() {
    if (user == null) return;

    _needSubbmitDataController.close();
    _needSubbmitDataController = StreamController();
    _needSubbmitDataController.stream.listen((d) {
      print("ddd submit: $d");
      RemoteDb.instance.updateOne(user!.id, d).then((_) {});
    });

    print("ddd");
    _taskStreamController.close();
    _taskStreamController = StreamController()
      ..addStream(RemoteDb.instance.listenDataChange<Task>(user!.id))
      ..stream.listen(onDbChange);

    _groupStreamController.close();
    _groupStreamController = StreamController()
      ..addStream(RemoteDb.instance.listenDataChange<Group>(user!.id))
      ..stream.listen(onDbChange);
  }

  void onDbChange<T extends TsData>((int, int, T?) d) {
    print("ddd: onDbChange: $d");
    final rawMap = _getRaw<T>();
    if (rawMap.containsKey(d.$1) && d.$2 <= rawMap[d.$1]!.updateTimestampAt) return;
    print("ddd willDown $d");
    // print("ddd ts:, ${(d.$3 as Task).status}");

    if (d.$3 == null) {
      rawMap.remove(d.$1);
    } else {
      rawMap[d.$1] = d.$3!;
    }
    _onDataChanged();
  }

  Future<void> syncAll() async {
    await syncData<Group>();
    await syncData<Task>();
    getUserInfo();
    _onDataChanged();
  }

  // 全量同步
  Future<void> syncData<T extends TsData>() async {
    if (user == null) return;

    // 1. 数据新旧比较
    Set<int> cloudNewIds = {}; // 数据库数据新  -> 更新本地
    Set<int> localNewIds = {}; // 本地数据新    -> 上数据库
    final rawMap = _getRaw<T>();

    // 1.1 云端数据
    final tt = await RemoteDb.instance.getWithTime<T>(user!.id);
    for (final (id, updateAt) in tt) {
      // print("ddd: $id, ${rawMap[id]!.updateTimestampAt} $updateAt");
      if (!rawMap.containsKey(id) || rawMap[id]!.updateTimestampAt < updateAt) {
        cloudNewIds.add(id);
      } else if (rawMap[id]!.updateTimestampAt > updateAt) {
        localNewIds.add(id);
      }
    }
    // 1.2 本地数据: 云端没有的 -> 本地新
    final tti = tt.map((e) => e.$1);
    for (final i in rawMap.keys) {
      if (!tti.contains(i)) {
        localNewIds.add(i);
      }
    }

    print("ddd cloud: $cloudNewIds");
    print("ddd local: $localNewIds");

    // 2.1 更新本地数据
    final it = await RemoteDb.instance.getData<T>(user!.id, cloudNewIds.toList());
    rawMap.cover(it);

    // 2.2 检测未分组数据转移至默认分组
    final defaultGroupId = rawGroup.keys.min();
    final defaultGroup = rawGroup[defaultGroupId]!;
    final okTaskIds = rawGroup.values.map((g) => g.taskIds).expand((l) => l);

    for (final ti in rawTask.keys) {
      if (!okTaskIds.contains(ti)) {
        defaultGroup.taskIds.add(ti);
        localNewIds.add(defaultGroupId);
      }
    }

    // 3. 更新数据库数据
    await RemoteDb.instance.update<T>(user!.id, {for (var i in localNewIds) i: rawMap[i]!});

    // 4. 通知
    _onDataChanged();
  }

  Map<int, T> _getRaw<T extends TsData>([T? d]) {
    if (T == Task || d is Task) return rawTask as Map<int, T>;
    if (T == Group || d is Group) return rawGroup as Map<int, T>;
    throw Exception("Unknown type");
  }
}

enum _DataChangeType {
  groupOrTask,
  user,
}
