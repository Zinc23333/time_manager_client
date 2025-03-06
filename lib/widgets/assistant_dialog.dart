import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_manager_client/data/controller/data_controller.dart';
import 'package:time_manager_client/data/repository/logger.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/helper/coordinate_helper.dart';
import 'package:time_manager_client/helper/extension.dart';
import 'package:time_manager_client/helper/helper.dart';

class AssistantDialog extends StatefulWidget {
  const AssistantDialog({super.key});

  @override
  State<AssistantDialog> createState() => _AssistantDialogState();
}

class _AssistantDialogState extends State<AssistantDialog> {
  late final screenSize = MediaQuery.of(context).size;
  late final textTheme = Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white);
  late final c = DataController.to;
  late final now = DateTime.now();
  late final tasks = c.tasks.where((e) => e.startTime?.isSameDay(now) ?? false).toList();

  @override
  void initState() {
    super.initState();
    tasks.sort((a, b) => a.startTime!.compareTo(b.startTime!));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Center(
          child: SizedBox(
            width: screenSize.width * 0.8,
            height: screenSize.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("助手", style: textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text("以下是为您规划的今天的行程。", style: textTheme.bodyMedium),
                const SizedBox(height: 16),
                Expanded(
                    child: SingleChildScrollView(
                        child: SizedBox(
                  width: screenSize.width * 0.8,
                  height: tasks.length * 100 + 20,
                  child: buildTasks(),
                )))
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildTasks() {
    return Stack(
      children: [
        Positioned(
          left: 100,
          width: 2,
          top: 0,
          bottom: 0,
          child: VerticalDivider(),
        ),
        for (final (tno, task) in Helper.enumerate(tasks))
          Positioned(
            left: 128,
            right: 0,
            height: 80,
            top: tno * 100,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(24),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: textTheme.titleMedium),

                  Row(children: [Icon(Icons.location_pin, color: Colors.white, size: 16), Text(task.location ?? "未知地点", style: textTheme.bodyMedium)]),
                  Row(children: [Icon(Icons.date_range, color: Colors.white, size: 16), Text(task.startTimeWithPrecision, style: textTheme.bodyMedium)]),
                  // Text(task.startTimeWithPrecision, style: TextStyle(fontSize: 12)),
                  // Text(task.endTimeWithPrecision, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        for (final (tno, task) in Helper.enumerate(tasks))
          Positioned(
            left: 85,
            top: tno * 100 + 25,
            width: 30,
            height: 30,
            child: task.status == TaskStatus.finished
                ? Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: Icon(Icons.check_rounded, color: Colors.white, size: 30),
                  )
                : Center(child: Icon(Icons.circle, color: Colors.white, size: 28)),
            // child: task.status == TaskStatus.finished ? Icon(Icons.check_circle, color: Colors.green) : Icon(Icons.circle, color: Colors.white),
          ),
        for (int i = 0; i < tasks.length - 1; i++) buildDetla(i),
      ],
    );
  }

  Widget buildDetla(int i) {
    final prev = tasks[i];
    final next = tasks[i + 1];

    String deltaTime = "";
    logger.d("${prev.startTime} -> ${next.startTime}");
    if (next.startTime != null && prev.startTime != null) {
      int dtm = next.startTime!.difference(prev.startTime!).inMinutes;
      int dth = dtm ~/ 60;
      dtm %= 60;
      if (dth > 0) deltaTime += "${dth}h ";
      deltaTime += "${dtm}min";
    }

    String deltaLocation = "";
    if (next.latLng != null && prev.latLng != null) {
      double distance = CoordinateHelper.calculateDistance(prev.latLng!, next.latLng!);
      deltaLocation = "${distance.toStringAsFixed(2)}km";
    }

    return Positioned(
      top: i * 100 + 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(deltaTime, style: textTheme.bodyMedium),
          Text(deltaLocation, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
