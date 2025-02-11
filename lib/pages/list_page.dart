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

  @override
  Widget build(BuildContext context) {
    return CheckMarkIndicator(
      onRefresh: DataController.to.syncAll,
      child: GetBuilder<DataController>(
        builder: (s) {
          final tasks = DataController.to.currentGroupTasks.toList();
          return ListView.separated(
            itemBuilder: (context, index) {
              final task = tasks[index];
              final textStyle = Helper.if_(task.status.isFinished, taskFinishedTextStyle);
              return ListTile(
                title: Text(tasks[index].title, style: textStyle),
                subtitle: Helper.if_(task.summary?.isNotEmpty ?? false, Text(task.summary!, style: textStyle)),
                onTap: () {
                  ViewTaskWidget.show(context, tasks[index]);
                },
                leading: IconButton(
                  onPressed: () {
                    DataController.to.changeTaskStatus(tasks[index]);
                    setState(() {});
                  },
                  icon: tasks[index].status.isFinished ? Icon(Icons.check_circle) : Icon(Icons.circle_outlined),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 12);
            },
            itemCount: tasks.length,
          );
        },
      ),
    );
  }
}
