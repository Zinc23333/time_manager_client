import 'package:time_manager_client/data/environment/constant.dart';
import 'package:time_manager_client/data/types/task.dart';

class WebCrawlerTasks {
  final String title;
  final String url;
  final List<Task> tasks;
  final String? mindmap;

  const WebCrawlerTasks(this.title, this.url, this.tasks, [this.mindmap]);

  String get mindmapText => Constant.mindmapWebCode.replaceFirst("###MINDMAP###", mindmap!);
  (String, List<String>) get mindmapOutline {
    final lines = mindmap!.split("\n");
    return (lines.first.substring(2), lines.where((e) => e.startsWith("  - ")).map((e) => e.substring(4)).toList());
  }
}
