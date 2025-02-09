import 'package:time_manager_client/data/types/tw_data.dart';

import 'package:time_manager_client/data/proto.gen/group.pb.dart' as p;
import 'package:time_manager_client/helper/extension.dart';

class Group extends TsData {
  String title;
  String icon;
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

  @override
  String toString() => "Group($iconAndTitle, $taskIds)";

  @override
  p.Group toProto() => p.Group(
        title: title,
        icon: icon,
        taskIds: taskIds.map((e) => e.toInt64()),
        updateTimestampAt: updateTimestampAt.toInt64(),
      );

  factory Group.fromProto(p.Group g) {
    return Group(
      title: g.title,
      icon: g.icon,
      taskIds: g.taskIds.map((e) => e.toInt()).toList(),
      updateTimestamp: g.updateTimestampAt.toInt(),
    );
  }
}
