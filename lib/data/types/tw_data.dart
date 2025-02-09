// class Tw<T extends TwData> {
//   final int timestamp;
//   final T data;

//   Tw(this.timestamp, this.data);

//   Tw.now(this.data) : timestamp = DateTime.now().millisecondsSinceEpoch;
//   Tw.zero(this.data) : timestamp = 0;
// }

import 'package:protobuf/protobuf.dart';

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
}
