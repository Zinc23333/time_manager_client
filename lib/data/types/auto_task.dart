import 'package:time_manager_client/data/proto.gen/auto_task.pb.dart' as p;
import 'package:time_manager_client/helper/extension.dart';

class AutoTask {
  DateTime executeAt;
  String demand;
  bool executed;
  bool successed;
  String log;

  AutoTask(this.executeAt, this.demand, [this.executed = false, this.successed = false, this.log = ""]);

  factory AutoTask.fromMap(Map<String, dynamic> map) => AutoTask(
        DateTime.fromMillisecondsSinceEpoch(map["executeAt"]),
        map["demand"],
        map["executed"],
        map["successed"],
        map["log"],
      );

  static AutoTask? fromMapNullable(Map<String, dynamic>? map) =>
      (map == null || !map.containsKey("executeAt") || !map.containsKey("demand")) ? null : AutoTask.fromMap(map);

  Map<String, dynamic> toMap() => {
        "executeAt": executeAt.millisecondsSinceEpoch,
        "demand": demand,
        "executed": executed,
        "successed": successed,
        "log": log,
      };

  p.AutoTask toProto() => p.AutoTask(
        executeAt: executeAt.millisecondsSinceEpoch.toInt64(),
        demand: demand,
        executed: executed,
        successed: successed,
        log: log,
      );

  AutoTask.fromProto(p.AutoTask t)
      : executeAt = DateTime.fromMillisecondsSinceEpoch(t.executeAt.toInt()),
        demand = t.demand,
        executed = t.executed,
        successed = t.successed,
        log = t.log;
}
