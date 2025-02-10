// class Tw<T extends TwData> {
//   final int timestamp;
//   final T data;

//   Tw(this.timestamp, this.data);

//   Tw.now(this.data) : timestamp = DateTime.now().millisecondsSinceEpoch;
//   Tw.zero(this.data) : timestamp = 0;
// }

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
    switch (T) {
      case Group _:
        return Group.fromMapNullable(map) as T?;
      case Task _:
        return Task.fromMapNullable(map) as T?;

      default:
        throw UnimplementedError();
    }
  }

  static String getTableName<T>() {
    switch (T) {
      case Group _:
        return 'groups';
      case Task _:
        return 'tasks';

      default:
        throw UnimplementedError();
    }
  }
}
