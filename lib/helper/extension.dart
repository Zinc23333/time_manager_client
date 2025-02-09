import 'package:fixnum/fixnum.dart' as fixnum;

extension DateTimeEx on DateTime {
  String formatWithPrecision(int precision) {
    final l = [year, month, day, hour, minute, second];
    final s = "-- ::x";
    final r = List.generate(precision + 1, (i) => i).map((i) => "${l[i].toString().padLeft(2, "0")}${s[i]}").join();
    return r.substring(0, r.length - 1);
  }
}

extension IntEx on int {
  fixnum.Int64 toInt64() => fixnum.Int64(this);
}

extension Int64Ex on fixnum.Int64 {
  DateTime toDateTime() {
    final milliseconds = toInt();
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }
}
