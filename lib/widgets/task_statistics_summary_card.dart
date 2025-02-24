import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:time_manager_client/data/controller/data_controller.dart';
import 'package:time_manager_client/data/types/task.dart';

class TaskStatisticsSummaryCard extends StatefulWidget {
  const TaskStatisticsSummaryCard({super.key});

  @override
  State<TaskStatisticsSummaryCard> createState() => _TaskStatisticsSummaryCardState();
}

class _TaskStatisticsSummaryCardState extends State<TaskStatisticsSummaryCard> {
  final vn = ValueNotifier(0.0);
  late final titleLarge = Theme.of(context).textTheme.titleLarge;

  @override
  Widget build(BuildContext context) {
    final tasks = DataController.to.tasks;
    final taskCount = tasks.length;
    final unfinCount = tasks.where((e) => e.status == TaskStatus.unfinished).length;
    final finCount = taskCount - unfinCount;
    final taskCountNotZero = taskCount == 0 ? 1 : taskCount;
    vn.value = 100 * finCount / taskCountNotZero;

    print(vn.value);

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 8, 8),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            SimpleCircularProgressBar(
              maxValue: 100,
              size: 128,
              animationDuration: 1,
              mergeMode: true,
              progressStrokeWidth: 25,
              backStrokeWidth: 25,
              valueNotifier: vn,
              onGetText: (t) => Text(
                "${t.toStringAsPrecision(3)}%",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(width: 32),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "总共有 "),
                  TextSpan(text: taskCount.toString(), style: titleLarge?.copyWith(color: Colors.blue)),
                  TextSpan(text: " 个任务"),
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "已完成 "),
                  TextSpan(text: finCount.toString(), style: titleLarge?.copyWith(color: Colors.green)),
                  TextSpan(text: " 个任务"),
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "还剩下 "),
                  TextSpan(text: unfinCount.toString(), style: titleLarge?.copyWith(color: Colors.red)),
                  TextSpan(text: " 个任务"),
                ])),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
