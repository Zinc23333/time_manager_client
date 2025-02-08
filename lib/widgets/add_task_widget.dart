import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/controller.dart';
import 'package:time_manager_client/data/task.dart';
import 'package:time_manager_client/helper/helper.dart';
import 'package:time_manager_client/widgets/add_task_from_text_widget.dart';
import 'package:time_manager_client/widgets/star_rate_widget.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key});

  static void show(BuildContext context) => Helper.showModalBottomSheetWithTextField(context, AddTaskWidget());

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  bool expand = false;
  int? importance;
  DateTime? startDateTime;
  DateTime? endDateTime;

  bool _lastTaskTitleIsEmpty = true;
  late final _inputList = Task.inputFieldParams.map((e) => (e.$1, e.$2, e.$3, TextEditingController())).toList();

  late final _inputListWidget = [
    for (final ip in _inputList.sublist(2))
      TextField(
        controller: ip.$4,
        keyboardType: TextInputType.text,
        autofocus: true,
        style: Theme.of(context).textTheme.titleSmall,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints.tightForFinite(),
          prefixIcon: Icon(ip.$2, size: 14),
          hintText: ip.$1,
          border: InputBorder.none,
          isCollapsed: true,
        ),
      )
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _inputList[0].$4,
                keyboardType: TextInputType.text,
                autofocus: true,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  hintText: "准备做的任务",
                  border: InputBorder.none,
                  isCollapsed: true,
                  prefixIcon: Helper.if_(expand, Icon(Icons.flag_outlined)),
                  prefixIconConstraints: BoxConstraints.tightForFinite(),
                ),
                onChanged: (value) {
                  if (value.isEmpty != _lastTaskTitleIsEmpty) {
                    _lastTaskTitleIsEmpty = value.isEmpty;
                    setState(() {});
                  }
                },
              ),
              TextField(
                controller: _inputList[1].$4,
                keyboardType: TextInputType.text,
                autofocus: true,
                style: Theme.of(context).textTheme.titleSmall,
                decoration: InputDecoration(
                  hintText: "内容概述",
                  border: InputBorder.none,
                  isCollapsed: true,
                  prefixIcon: Helper.if_(expand, Icon(Icons.label_outline, size: 14)),
                  prefixIconConstraints: BoxConstraints.tightForFinite(),
                ),
              ),
              if (expand) ..._inputListWidget,
            ],
          ),
        ),
        buildBottomButtons()
      ],
    );
  }

  Widget buildBottomButtons() {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          IconButton(
            onPressed: bSetDate,
            isSelected: startDateTime != null,
            icon: Icon(endDateTime == null ? Icons.date_range_rounded : Icons.calendar_month_rounded),
          ),
          IconButton(
            onPressed: bStarRate,
            isSelected: importance != null,
            icon: Icon(Icons.star_rounded),
          ),
          IconButton(
            onPressed: bExpand,
            isSelected: expand,
            icon: Icon(Icons.more_horiz_rounded),
          ),
          Expanded(child: SizedBox()),
          if (_inputList[0].$4.text.isNotEmpty)
            SizedBox(
              height: 30,
              width: 60,
              child: ElevatedButton(
                onPressed: bFinish,
                child: Icon(Icons.send_rounded),
                // isSelected: true,
              ),
            )
          else
            IconButton(
              onPressed: bFromClipboard,
              icon: Icon(Icons.copy),
            ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  void bFinish() {
    if (_inputList[0].$4.text.isEmpty) return;
    Controller.to.addTask(
      Task.fromController(
        _inputList.map((e) => e.$4).toList(),
        startTime: startDateTime,
        endTime: endDateTime,
        importance: importance,
      ),
    );
    Navigator.of(context).pop();
  }

  void bFromClipboard() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskPage()));
    Get.back();
    AddTaskFromTextWidget.show(context);
  }

  void bSetDate() async {
    final dts = await Helper.showDateTimeRangePicker(context);
    startDateTime = dts?.$1;
    endDateTime = dts?.$2;
    setState(() {});
  }

  void bStarRate() async {
    importance = await StarRateWidget.show(context, importance);
    setState(() {});
  }

  void bExpand() {
    expand = !expand;
    setState(() {});
  }
}
