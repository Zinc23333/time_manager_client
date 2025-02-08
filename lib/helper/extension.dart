extension DateTimeEx on DateTime {
  String formatWithPrecision(int precision) {
    final l = [year, month, day, hour, minute, second];
    final s = "-- ::x";
    final r = List.generate(precision + 1, (i) => i).map((i) => "${l[i].toString().padLeft(2, "0")}${s[i]}").join();
    return r.substring(0, r.length - 1);
  }
}
