import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/helper/helper.dart';

class MultiTaskSelectorBottomSheet extends StatelessWidget {
  const MultiTaskSelectorBottomSheet({super.key, required this.tasks, this.onSelected});

  final List<Task> tasks;
  final void Function(Task)? onSelected;

  static Future<Task?> show(BuildContext context, List<Task> tasks, {void Function(Task)? onSelected}) =>
      Helper.showModalBottomSheetWithTextField<Task>(context, MultiTaskSelectorBottomSheet(tasks: tasks, onSelected: onSelected));

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(tasks[index].title),
        subtitle: Text(tasks[index].summary ?? ""),
        onTap: () {
          if (onSelected == null) {
            Get.back(result: tasks[index]);
          } else {
            onSelected?.call(tasks[index]);
          }
        },
      ),
    );
  }
}
