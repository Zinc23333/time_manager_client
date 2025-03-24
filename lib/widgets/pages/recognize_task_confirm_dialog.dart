import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/pages/edit_task_page.dart';

class RecognizeTaskConfirmDialog extends StatelessWidget {
  final Task task;
  const RecognizeTaskConfirmDialog(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(task.title),
      content: Column(
        children: [Text(task.summary ?? "")],
      ),
      actions: [
        TextButton(onPressed: () => Get.to(() => EditTaskPage(old: task)), child: Text("编辑")),
        ElevatedButton(onPressed: () {}, child: Text("完成")),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}
