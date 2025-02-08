import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:time_manager_client/data/types/task.dart';
import 'package:time_manager_client/helper/helper.dart';

class StarRateWidget extends StatefulWidget {
  const StarRateWidget({super.key, this.last});

  final int? last;

  static Future<int?> show(BuildContext context, [int? last]) => Helper.showModalBottomSheetWithTextField<int>(context, StarRateWidget(last: last));

  @override
  State<StarRateWidget> createState() => _StarRateWidgetState();
}

class _StarRateWidgetState extends State<StarRateWidget> {
  late double rate = widget.last?.toDouble() ?? 0;
  late TextEditingController controller = TextEditingController(text: rate.toInt().toString());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      GFRating(
        value: rate,
        allowHalfRating: false,
        borderColor: theme.unselectedWidgetColor,
        color: theme.colorScheme.primary,
        onChanged: (value) {
          rate = value;
          controller = TextEditingController(text: rate.toInt().toString());
          setState(() {});
        },
      ),
      SizedBox(width: 16),
      SizedBox(
        width: 20,
        child: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
          decoration: InputDecoration(border: InputBorder.none),
          onChanged: (value) {
            if (value.length > 1) controller.text = value[value.length - 1];
            rate = double.tryParse(controller.text) ?? rate;
            rate = max(rate, 0);
            rate = min(rate, 5);
            setState(() {});
          },
        ),
      ),
      SizedBox(
        width: 60,
        child: Text(Task.importanceInfo[rate.toInt()]),
      ),
      TextButton(
        onPressed: () {
          final r = rate.toInt();
          Navigator.of(context).pop(r == 0 ? null : r);
        },
        child: Text("完成"),
      ),
    ]);
  }
}
