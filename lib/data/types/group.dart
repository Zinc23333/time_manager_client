import 'package:time_manager_client/data/types/tw_data.dart';

class Group extends TwData {
  String title;
  String icon;
  // List<Task> tasks;
  List<int> taskIds;

  Group({
    required this.title,
    required this.icon,
    required this.taskIds,
    int? updateTimestamp,
  }) : super(updateTimestamp);

  Group.title(this.title)
      : icon = "📂",
        taskIds = [];

  String get iconAndTitle => "$icon $title";
}
