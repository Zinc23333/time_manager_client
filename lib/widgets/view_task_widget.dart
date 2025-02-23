import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/helper/extension.dart';
import 'package:time_manager_client/helper/helper.dart';
import 'package:time_manager_client/pages/edit_task_page.dart';

class ViewTaskWidget extends StatelessWidget {
  const ViewTaskWidget({super.key, required this.task});

  final Task task;

  static void show(BuildContext context, Task task) => Helper.showModalBottomSheetWithTextField(context, ViewTaskWidget(task: task));

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.inversePrimary;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
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
                    Get.off(() => EditTaskPage(old: task));
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
            // 日期和重要性
            Wrap(
              children: [
                if (task.startTime != null)
                  InkWell(
                    onTap: task.onDateTimeClick,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.date_range, color: iconColor),
                        SizedBox(width: 8),
                        Text(task.startTimeWithPrecision),
                        if (task.endTime != null) Text(" ~ "),
                        if (task.endTime != null) Text(task.endTimeWithPrecision),
                        Icon(Icons.open_in_new_rounded, size: 16, color: iconColor),
                        SizedBox(width: 16),
                      ],
                    ),
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
            // 提醒
            if (task.noticeTimes.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications, color: iconColor),
                  SizedBox(width: 8),
                  Text(task.noticeTimes.map((d) => d.formatWithPrecision(5)).join(" ")),
                ],
              ),

            // 其他文本信息
            for (final pi in task.paramAndInfo().sublist(2))
              if (pi.$3?.isNotEmpty ?? false) buildInfoRow(pi, iconColor),
          ],
        ),
      ),
    );
  }

  Row buildInfoRow((String, IconData, String?, void Function()?) pi, Color iconColor) {
    return Row(
      children: [
        Icon(pi.$2, color: iconColor),
        SizedBox(width: 8),
        if (pi.$4 == null)
          Expanded(child: Text(pi.$3!))
        else
          Expanded(
              child: InkWell(
            onTap: pi.$4,
            child: Row(children: [
              Text(pi.$3!),
              Icon(Icons.open_in_new_rounded, size: 16, color: iconColor),
            ]),
          ))
      ],
    );
  }
}
