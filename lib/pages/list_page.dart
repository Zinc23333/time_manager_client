import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/controller.dart';
import 'package:time_manager_client/widgets/view_task_widget.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      builder: (s) {
        final tasks = Controller.to.currentGroupTasks.toList();
        return ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                tasks[index].title,
                style: tasks[index].status.isFinished
                    ? TextStyle(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      )
                    : null,
              ),
              onTap: () {
                ViewTaskWidget.show(context, tasks[index]);
              },
              leading: IconButton(
                onPressed: () {
                  Controller.to.changeTaskStatus(tasks[index]);
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
    );
  }
}
