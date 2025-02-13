import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/3rd/check_mark_indicator.dart';
import 'package:time_manager_client/data/controller/data_controller.dart';
import 'package:time_manager_client/helper/helper.dart';
import 'package:time_manager_client/widgets/view_task_widget.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final taskFinishedTextStyle = TextStyle(
    fontStyle: FontStyle.italic,
    decoration: TextDecoration.lineThrough,
    color: Colors.grey,
  );

  static final Widget _loading = ListTile(
    leading: IconButton(icon: Icon(Icons.circle, color: Colors.grey.withAlpha(40)), onPressed: () {}),
    title: Row(children: [Container(width: 120, height: 20, color: Colors.grey.withAlpha(40))]),
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (s) {
        final tasks = s.currentGroupTasks.toList();
        return CheckMarkIndicator(
          onRefresh: s.syncAll,
          child: ListView.separated(
            itemBuilder: (context, index) {
              final task = tasks[index];

              if (task.isLoading) return _loading;

              final textStyle = Helper.if_(task.status.isFinished, taskFinishedTextStyle);
              return ListTile(
                title: Text(tasks[index].title, style: textStyle),
                subtitle: (task.summary?.isNotEmpty ?? false)
                    ? Text(
                        task.summary!,
                        style: textStyle,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                onTap: () {
                  ViewTaskWidget.show(context, tasks[index]);
                },
                leading: IconButton(
                  onPressed: () {
                    DataController.to.changeTaskStatus(tasks[index]);
                    setState(() {});
                  },
                  icon: task.status.isFinished ? Icon(Icons.check_circle) : Icon(Icons.circle_outlined),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 12);
            },
            itemCount: tasks.length,
          ),
        );
      },
    );
  }
}
