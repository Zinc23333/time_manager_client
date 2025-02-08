import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:time_manager_client/data/controller.dart';
import 'package:time_manager_client/data/task.dart';
import 'package:time_manager_client/helper/extension.dart';
import 'package:time_manager_client/helper/helper.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key, this.old});

  final Task? old;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final formKey = GlobalKey<FormState>();
  bool expandTimePrecision = false;

  late int importance = widget.old?.importance ?? 0;
  late final importanceController = TextEditingController(text: Helper.if_(importance != 0, importance.toString()));

  late int? startTimePrecision = widget.old?.startTimePrecision;
  late int? endTimePrecision = widget.old?.endTimePrecision;
  late DateTime? startTime = widget.old?.startTime;
  late DateTime? endTime = widget.old?.endTime;
  final dateController = TextEditingController();

  late final controllers = widget.old?.paramAndInfo().map((e) => TextEditingController(text: e.$3)).toList() ??
      List.generate(Task.inputFieldParams.length, (_) => TextEditingController());

  late final _timePrecisionList = [
    ("开始时间精度:", () => startTimePrecision, (index) => startTimePrecision = index),
    ("结束时间精度:", () => endTimePrecision, (index) => endTimePrecision = index),
  ];

  @override
  void initState() {
    super.initState();
    updateTimePrecision(false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double expandTimePrecisionHeight = expandTimePrecision && startTime != null
        ? endTime != null
            ? 64
            : 34
        : 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("编辑任务"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              for (final pc in Helper.zip(Task.inputFieldParams, controllers))
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: pc.$2,
                  autofocus: true,
                  decoration: InputDecoration(
                    prefixIconConstraints: BoxConstraints.tightForFinite(),
                    prefixIcon: Icon(pc.$1.$2),
                    labelText: pc.$1.$1,
                    border: UnderlineInputBorder(),
                  ),
                  validator: Helper.if_(!pc.$1.$3, (v) => Helper.if_(v == null || v.isEmpty, '请输入${pc.$1.$1}')),
                ),
              TextFormField(
                autofocus: true,
                readOnly: true,
                controller: dateController,
                onTap: dateEditClicked,
                decoration: InputDecoration(
                    prefixIconConstraints: BoxConstraints.tightForFinite(),
                    prefixIcon: Icon(Icons.date_range_outlined),
                    labelText: "日期",
                    border: UnderlineInputBorder(),
                    suffixIcon: Helper.if_(
                        startTime != null,
                        ExpandIcon(
                          isExpanded: expandTimePrecision,
                          onPressed: (_) {
                            expandTimePrecision = !expandTimePrecision;
                            setState(() {});
                          },
                        ))),
              ),
              AnimatedContainer(
                duration: Durations.medium1,
                height: expandTimePrecisionHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 4),
                    for (final tp in _timePrecisionList.sublist(0, endTime != null ? 2 : 1))
                      SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            Text(tp.$1),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: Task.timePricisions.length,
                                separatorBuilder: (context, index) => SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final s = Task.timePricisions[index];
                                  return GFRadio(
                                    value: index,
                                    groupValue: tp.$2(),
                                    onChanged: (value) {
                                      tp.$3(value);
                                      updateTimePrecision();
                                    },
                                    inactiveIcon: Center(child: Text(s)),
                                    type: GFRadioType.custom,
                                    size: 28,
                                    customBgColor: Colors.transparent,
                                    inactiveBgColor: Colors.transparent,
                                    activeBgColor: theme.colorScheme.inversePrimary,
                                    activeIcon: Center(child: Text(s, style: TextStyle(color: Colors.white))),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              TextFormField(
                autofocus: true,
                controller: importanceController,
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                onChanged: importanceTextChanged,
                validator: importanceTextValidator,
                decoration: InputDecoration(
                  prefixIconConstraints: BoxConstraints.tightForFinite(),
                  prefixIcon: Icon(Icons.star_outlined),
                  labelText: "评分",
                  border: UnderlineInputBorder(),
                  suffix: GFRating(
                    onChanged: importanceRateChanged,
                    value: importance.toDouble(),
                    allowHalfRating: false,
                    size: GFSize.SMALL,
                    padding: EdgeInsets.zero,
                    borderColor: theme.unselectedWidgetColor,
                    color: theme.colorScheme.inversePrimary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final task = Task.fromController(
                      controllers,
                      startTime: startTime,
                      startTimePrecision: startTimePrecision,
                      endTime: endTime,
                      endTimePrecision: endTimePrecision,
                      importance: importance,
                    );
                    if (widget.old == null) {
                      Controller.to.addTask(task);
                    } else {
                      Controller.to.editTask(widget.old!, task);
                    }
                    Get.back();
                  }
                },
                child: Text("完成"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dateEditClicked() {
    Helper.showDateTimeRangePicker(context).then((dts) {
      startTime = dts?.$1;
      endTime = dts?.$2;

      if (startTime == null) {
        startTimePrecision = null;
      } else {
        startTimePrecision = startTimePrecision ?? 5;
      }

      if (endTime == null) {
        endTimePrecision = null;
      } else {
        endTimePrecision = endTimePrecision ?? 5;
      }

      updateTimePrecision();
    });
  }

  void updateTimePrecision([bool refresh = true]) {
    String r = startTime?.formatWithPrecision(startTimePrecision ?? 5) ?? "";
    if (endTime != null) {
      r += " ~ ${endTime?.formatWithPrecision(endTimePrecision ?? 5)}";
    }
    dateController.text = r;
    if (refresh) setState(() {});
  }

  void importanceRateChanged(double rating) {
    importance = rating.toInt();
    importanceController.text = importance.toString();
    setState(() {});
  }

  String? importanceTextValidator(value) {
    if (value != null && value.isNotEmpty) {
      final int rating = int.parse(value);
      if (rating < 1 || rating > 5) return "请输入1~5的整数";
    }
    return null;
  }

  void importanceTextChanged(value) {
    if (value.length > 1) {
      importanceController.text = value[value.length - 1];
    }
    final r = int.tryParse(importanceController.text) ?? 0;
    importance = max(0, r);
    importance = min(5, r);
    importanceController.text = importance.toString();
    setState(() {});
  }
}
