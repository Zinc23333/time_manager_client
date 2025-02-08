import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/task.dart';
import 'package:time_manager_client/helper/helper.dart';
import 'package:time_manager_client/pages/edit_task_page.dart';

class ViewTaskWidget extends StatelessWidget {
  const ViewTaskWidget({super.key, required this.task});

  final Task task;

  static void show(BuildContext context, Task task) => Helper.showModalBottomSheetWithTextField(context, ViewTaskWidget(task: task));

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: null,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.off(EditTaskPage(old: task));
                    },
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
              if (task.summary != null) Text(task.summary!),
              if (task.content != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 32,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("原文"),
                              content: Text(task.content ?? "无"),
                            ),
                          );
                        },
                        child: Text(
                          "查看原文",
                          style: TextStyle(fontSize: Theme.of(context).textTheme.bodySmall?.fontSize),
                        ),
                      ),
                    ),
                  ],
                ),
              Divider(),
              Wrap(
                children: [
                  if (task.startTime != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.date_range),
                        SizedBox(width: 8),
                        Text(task.startTimeWithPrecision),
                        if (task.endTime != null) Text(" ~ "),
                        if (task.endTime != null) Text(task.endTimeWithPrecision),
                        SizedBox(width: 16),
                      ],
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      task.importance ?? 0,
                      (_) => Icon(Icons.star_rounded, color: Colors.amber),
                    ),
                  ),
                ],
              ),
              for (final pi in task.paramAndInfo().sublist(2))
                if (pi.$3?.isNotEmpty ?? false)
                  Row(
                    children: [
                      Icon(pi.$2),
                      SizedBox(width: 8),
                      Expanded(child: Text(pi.$3!)),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
