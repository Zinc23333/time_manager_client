import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/group.dart';
import 'package:time_manager_client/data/task.dart';

class Controller extends GetxController {
  static Controller get to => Get.find();

  final List<Group> groups = [
    Group(
      title: "默认分组",
      icon: "📢",
      color: Colors.red,
      tasks: [],
    ),
  ];

  late final currentGroup = groups.first.obs;

  void addTask(Task task, [Group? group]) {
    group ??= currentGroup.value;
    group.tasks.add(task);
    update();
  }

  void editTask(Task oldTask, Task newTask, [Group? group]) {
    group ??= currentGroup.value;
    final index = group.tasks.indexOf(oldTask);
    // if (index == -1) return;
    if (index == -1) {
      group.tasks.add(newTask);
    } else {
      group.tasks[index] = newTask;
    }
    update();
  }

  void changeTaskStatus(Task task, [TaskStatus? status]) {
    status ??= task.status == TaskStatus.finished ? TaskStatus.unfinished : TaskStatus.finished;
    task.status = status;
    update();
  }
}
