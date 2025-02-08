import 'dart:math';

import 'package:flutter/material.dart';
import 'package:time_manager_client/data/task.dart';

class Group {
  String title;
  String icon;
  Color color;
  List<Task> tasks;

  Group({
    required this.title,
    required this.icon,
    required this.color,
    required this.tasks,
  });

  final _random = Random();
  Group.title(this.title)
      : icon = "📂",
        color = Colors.transparent,
        tasks = [] {
    color = Colors.primaries[_random.nextInt(Colors.primaries.length)];
  }
}
