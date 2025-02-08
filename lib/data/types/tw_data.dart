// class Tw<T extends TwData> {
//   final int timestamp;
//   final T data;

//   Tw(this.timestamp, this.data);

//   Tw.now(this.data) : timestamp = DateTime.now().millisecondsSinceEpoch;
//   Tw.zero(this.data) : timestamp = 0;
// }

class TwData {
  int updateTimestampAt;
  TwData([timestamp]) : updateTimestampAt = timestamp ?? DateTime.now().millisecondsSinceEpoch;
  TwData.zero() : updateTimestampAt = 0;
  // String toJsonString() => "";

  void updateTimestamp() {
    updateTimestampAt = DateTime.now().millisecondsSinceEpoch;
  }
}
