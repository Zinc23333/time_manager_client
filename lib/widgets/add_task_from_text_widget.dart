import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/controller/data_controller.dart';
import 'package:time_manager_client/helper/helper.dart';
import 'package:time_manager_client/pages/edit_task_page.dart';
import 'package:time_manager_client/widgets/multi_task_selector_bottom_sheet.dart';

class AddTaskFromTextWidget extends StatefulWidget {
  const AddTaskFromTextWidget({super.key, this.futureText});
  final Future<String?>? futureText;

  static void show(BuildContext context, {Future<String?>? futureText}) => Helper.showModalBottomSheetWithTextField(
      context,
      AddTaskFromTextWidget(
        futureText: futureText,
      ));

  @override
  State<AddTaskFromTextWidget> createState() => _AddTaskFromTextWidgetState();
}

class _AddTaskFromTextWidgetState extends State<AddTaskFromTextWidget> {
  final controller = TextEditingController();

  DateTime? startSendTime;
  bool firstBuild = true;

  bool get enable => startSendTime == null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.futureText,
        builder: (context, snapshot) {
          if (snapshot.hasData && controller.text.isEmpty && firstBuild) {
            controller.text = snapshot.data!;
            firstBuild = false;
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: snapshot.connectionState == ConnectionState.waiting
                    ? SizedBox(
                        height: 128,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : TextField(
                        controller: controller,
                        autofocus: true,
                        enabled: enable,
                        minLines: 4,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "请在此粘贴文本，将由AI识别并提取任务信息。",
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
              ),
              if (!enable)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LinearProgressIndicator(),
                ),
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: Helper.if_(enable && controller.text.isNotEmpty, bSend),
                    child: Icon(Icons.send_rounded),
                  ),
                ],
              )
            ],
          );
        });
  }

  void bSend() async {
    if (controller.text.isEmpty) return;
    startSendTime = DateTime.now();
    setState(() {});

    final t = await DataController.to.getTaskFromText(controller.text);
    startSendTime = null;
    setState(() {});

    if (t.length == 1) Get.to(() => EditTaskPage(old: t.first));

    if (t.length > 1 && mounted) {
      await MultiTaskSelectorBottomSheet.show(
        context,
        t,
        onSelected: (ta) {
          Get.to(() => EditTaskPage(old: ta));
        },
      );
    }
  }
}
