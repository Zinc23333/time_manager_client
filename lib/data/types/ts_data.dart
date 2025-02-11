import 'package:protobuf/protobuf.dart';
import 'package:time_manager_client/data/types/group.dart';
import 'package:time_manager_client/data/types/task.dart';

class TsData {
  int updateTimestampAt;
  TsData([timestamp]) : updateTimestampAt = timestamp ?? DateTime.now().millisecondsSinceEpoch;
  TsData.zero() : updateTimestampAt = 0;
  // String toJsonString() => "";

  void updateTimestamp() {
    updateTimestampAt = DateTime.now().millisecondsSinceEpoch;
  }

  GeneratedMessage toProto() {
    throw UnimplementedError();
  }

  factory TsData.fromProto(GeneratedMessage proto) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toMap() => throw UnimplementedError();

  static T? fromMapNullable<T>(Map<String, dynamic> map) {
    if (T == Group) return Group.fromMapNullable(map) as T?;
    if (T == Task) return Task.fromMapNullable(map) as T?;
    throw Exception("Unknown type");
  }

  static String getTableName<T>() {
    if (T == Group) return 'groups';
    if (T == Task) return 'tasks';
    throw Exception("Unknown type");
  }
}
