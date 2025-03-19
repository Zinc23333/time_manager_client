import 'package:time_manager_client/data/proto.gen/mindmap.pb.dart' as p;
import 'package:time_manager_client/helper/extension.dart';

class Mindmap {
  List<int> taskIds;
  String mindmap;

  Mindmap(this.taskIds, this.mindmap);

  static Mindmap? fromText(String text, List<int> taskIds) {
    for (final line in text.split("\n")) {
      final l = line.trimLeft();
      if (l.isNotEmpty && !l.startsWith("- ")) return null;
    }
    return Mindmap(taskIds, text);
  }

  @override
  String toString() => "Mindmap($taskIds, $mindmap)";

  Map<String, dynamic> toMap() => {
        "taskIds": taskIds,
        "mindmap": mindmap,
      };

  Mindmap.fromMap(Map<String, dynamic> map)
      : taskIds = map["taskIds"].cast<int>(),
        mindmap = map["mindmap"];

  p.Mindmap toProto() => p.Mindmap(
        taskIds: taskIds.map((e) => e.toInt64()),
        mindmap: mindmap,
      );

  Mindmap.fromProto(p.Mindmap m)
      : taskIds = m.taskIds.map((e) => e.toInt()).toList(),
        mindmap = m.mindmap;
}
