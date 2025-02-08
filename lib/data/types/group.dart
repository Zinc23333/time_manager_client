import 'package:time_manager_client/data/types/task.dart';

class Group {
  String title;
  String icon;
  List<Task> tasks;

  Group({
    required this.title,
    required this.icon,
    required this.tasks,
  });

  Group.title(this.title)
      : icon = "📂",
        tasks = [];

  String get iconAndTitle => "$icon $title";
}
