import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:time_manager_client/data/controller.dart';
import 'package:time_manager_client/widgets/view_task_widget.dart';

class FourQuadrantPage extends StatefulWidget {
  const FourQuadrantPage({super.key});

  @override
  State<FourQuadrantPage> createState() => _FourQuadrantPageState();
}

class _FourQuadrantPageState extends State<FourQuadrantPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      builder: (s) {
        final tasks = Controller.to.currentGroup.value.tasks;
        return ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                tasks[index].title,
                style: tasks[index].status.isFinished
                    ? TextStyle(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.black54,
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
                icon: tasks[index].status.isFinished ? Icon(Icons.check_circle, color: Colors.black54) : Icon(Icons.circle_outlined),
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
    ;
  }
}
