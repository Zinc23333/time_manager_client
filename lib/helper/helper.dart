import 'dart:math';

import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class Helper {
  static T? if_<T>(bool condition, T thing, [T? other]) => condition ? thing : other;

  static Future<T?> showModalBottomSheetWithTextField<T>(BuildContext context, Widget child) => showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: child,
            ),
          );
        },
      );

  static Future<(DateTime, DateTime?)?> showDateTimeRangePicker(BuildContext context) async {
    final r = await showOmniDateTimeRangePicker(
      context: context,
      is24HourMode: true,
      isShowSeconds: true,
    );
    if (r == null || r.length != 2) return null;
    if (r[1].difference(r[0]).inSeconds < 2) return (r[0], null);
    return (r[0], r[1]);
  }

  static Iterable<(R, S)> zip<R, S>(Iterable<R> r, Iterable<S> s) sync* {
    for (int i = 0; i < min(r.length, s.length); i++) {
      yield (r.elementAt(i), s.elementAt(i));
    }
    return;
  }

  static Color? fromHexString(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";

    final r = int.tryParse(hexColor, radix: 16);
    if (r == null) return null;
    return Color(r);
  }
}
