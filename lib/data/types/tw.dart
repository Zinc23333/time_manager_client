class Tw<T extends TwData> {
  final int timestamp;
  final T data;

  Tw(this.timestamp, this.data);
}

abstract class TwData {
  String toJsonString() => "";
}
