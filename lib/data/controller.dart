import 'dart:math';

import 'package:get/get.dart';
import 'package:time_manager_client/data/types/group.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/data/types/tw_data.dart';

class Controller extends GetxController {
  static Controller get to => Get.find();

  final List<int> _groupIds = [0];
  Iterable<Group> get groups => _groupIds.map((e) => rawData[e]! as Group);

  final Map<int, TwData> rawData = {
    0: Group(
      title: "默认分组",
      icon: "📢",
      taskIds: [],
      updateTimestamp: 0,
    ),
  };

  late final currentGroup = groups.first.obs;
  Iterable<Task> get currentGroupTasks => currentGroup.value.taskIds.map((e) => rawData[e]! as Task);

  int getIndexNo() {
    if (rawData.keys.isEmpty) return 0;
    return rawData.keys.reduce((v, e) => max(v, e)) + 1;
  }

  void addTask(Task task, [Group? group]) {
    group ??= currentGroup.value;

    final index = getIndexNo();
    rawData[index] = task;
    group.taskIds.add(index);

    update();
  }

  void editTask(Task oldTask, Task newTask, [Group? group]) {
    group ??= currentGroup.value;

    int? index = rawData.entries.where((e) => e.value == oldTask).singleOrNull?.key;
    if (index == null) {
      index = getIndexNo();
      group.taskIds.add(index);
    }
    rawData[index] = newTask;

    update();
  }

  void changeTaskStatus(Task task, [TaskStatus? status]) {
    status ??= task.status == TaskStatus.finished ? TaskStatus.unfinished : TaskStatus.finished;
    task.status = status;
    task.updateTimestamp();
    update();
  }

  Group addGroup() {
    final g = Group.title("新建分组");
    final index = getIndexNo();
    rawData[index] = g;
    _groupIds.add(index);
    update();
    return g;
  }

  void changeGroupTitle(Group group, String title) {
    group.title = title;
    group.updateTimestamp();
    update();
  }

  void changeGroupIcon(Group group, String icon) {
    group.icon = icon;
    group.updateTimestamp();
    update();
  }

  void changeCurrentGroup(Group group) {
    currentGroup.value = group;
    update();
  }
}
