import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:time_manager_client/data/local_storage.dart';
import 'package:time_manager_client/data/remote_db.dart';
import 'package:time_manager_client/data/types/group.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/data/proto.gen/storage.pb.dart' as p;
import 'package:time_manager_client/helper/extension.dart';

class Controller extends GetxController {
  static Controller get to => Get.find();

  // 初始化
  Controller() {
    LocalStorage.instance?.init().then((_) {
      loadLocally();
    });
    RemoteDb.instance.init().then((_) {});
  }

  List<int> rawGroupIds = [0];
  Iterable<Group> get groups => rawGroupIds.map((e) => rawGroup[e]!);

  Map<int, Group> rawGroup = {0: Group(title: "默认分组", icon: "📢", taskIds: [], updateTimestamp: 0)};
  Map<int, Task> rawTask = {};

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

    onDataChanged();
  }

  void editTask(Task oldTask, Task newTask, [Group? group]) {
    group ??= currentGroup;

    int? index = rawTask.entries.where((e) => e.value == oldTask).singleOrNull?.key;
    if (index == null) {
      index = getTaskIndexNo();
      group.taskIds.add(index);
    }
    rawTask[index] = newTask;

    onDataChanged();
  }

  void changeTaskStatus(Task task, [TaskStatus? status]) {
    status ??= task.status == TaskStatus.finished ? TaskStatus.unfinished : TaskStatus.finished;
    task.status = status;
    task.updateTimestamp();
    onDataChanged();
  }

  Group addGroup() {
    final g = Group.title("新建分组");
    final index = getGroupIndexNo();
    rawGroup[index] = g;
    rawGroupIds.add(index);
    onDataChanged();

    return g;
  }

  void changeGroupTitle(Group group, String title) {
    group.title = title;
    group.updateTimestamp();
    onDataChanged();
  }

  void changeGroupIcon(Group group, String icon) {
    group.icon = icon;
    group.updateTimestamp();
    onDataChanged();
  }

  void changeCurrentGroup(Group group) {
    // currentGroup.value = group;
    currentGroupIndex.value = rawGroup.entries.where((e) => e.value == group).single.key;
    onDataChanged();
  }

  // 数据写入
  void onDataChanged() {
    update();
    LocalStorage.instance?.write(toProto());
  }

  // 导出
  p.Storage toProto() => p.Storage(
        groups: rawGroup.map((k, v) => MapEntry(k.toInt64(), v.toProto())),
        tasks: rawTask.map((k, v) => MapEntry(k.toInt64(), v.toProto())),
        groupIds: rawGroupIds.map((e) => e.toInt64()),
        currentGroupId: currentGroupIndex.value.toInt64(),
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
      rawGroup = r.$1;
      rawTask = r.$2;
      rawGroupIds = r.$3;
      currentGroupIndex.value = r.$4;
      update();
      if (data != null) LocalStorage.instance?.write(toProto());
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
    print("Phone: $i");
    if (i == null) {
      i = await RemoteDb.instance.signUpWithPhoneNumber(phone);
      print("Phone2: $i");
    }

    return false;
  }
}
