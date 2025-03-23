import 'package:flutter/material.dart';
import 'package:time_manager_client/data/controller/data_controller.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/helper/extension.dart';
import 'package:time_manager_client/widgets/pages/agent_running_dialog.dart';
import 'package:time_manager_client/widgets/fullscreen_blur_dialog.dart';

class AgentDialog extends StatefulWidget {
  const AgentDialog({super.key});

  @override
  State<AgentDialog> createState() => _AgentDialogState();
}

class _AgentDialogState extends State<AgentDialog> {
  late final textTheme = Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white);
  late final c = DataController.to;
  late final tasks = c.tasks.where((e) => e.autoTask != null).toList();
  late final nextAutoTask = tasks.where((e) => e.autoTask!.executable).firstOrNull;

  @override
  Widget build(BuildContext context) {
    return FullscreenBlurDialog(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("代理", style: textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text("即将为您执行以下任务", style: textTheme.bodyMedium),
        const SizedBox(height: 32),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final t = tasks[index];
              return buildTask(t);
            },
          ),
        )
      ],
    ));
  }

  Widget buildTask(Task t) {
    final ws = Row(
      children: [
        buildTime(t),
        buildLine(t),
        Expanded(child: buildCard(t)),
      ],
    );
    return t == nextAutoTask
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withAlpha(40),
                  Colors.blue.withAlpha(20),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: 100,
            child: ws,
          )
        : SizedBox(height: 100, child: ws);
  }

  Column buildLine(Task t) {
    return Column(
      children: [
        Expanded(child: SizedBox(width: 1, child: VerticalDivider())),
        Icon(t.autoTask!.state.icon, color: t.autoTask!.state.color),
        Expanded(child: SizedBox(width: 1, child: VerticalDivider())),
      ],
    );
  }

  SizedBox buildTime(Task t) {
    final time = t.autoTask!.executeAt.formatWithPrecision(5).split(" ");
    return SizedBox(
      width: 100,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(time.firstOrNull ?? "", style: textTheme.bodyMedium),
            Text(time.lastOrNull ?? "", style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Task t) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(24),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () {
          showDialog(context: context, builder: (context) => AgentRunningDialog(t));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.title, style: textTheme.titleMedium),
            Text(t.summary!, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
