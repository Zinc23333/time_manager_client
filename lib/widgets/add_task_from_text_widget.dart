import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/network.dart';
import 'package:time_manager_client/helper/helper.dart';
import 'package:time_manager_client/pages/edit_task_page.dart';

class AddTaskFromTextWidget extends StatefulWidget {
  const AddTaskFromTextWidget({super.key});
  static void show(BuildContext context) => Helper.showModalBottomSheetWithTextField(context, AddTaskFromTextWidget());

  @override
  State<AddTaskFromTextWidget> createState() => _AddTaskFromTextWidgetState();
}

class _AddTaskFromTextWidgetState extends State<AddTaskFromTextWidget> {
  final controller = TextEditingController();

  DateTime? startSendTime;

  bool get enable => startSendTime == null;

  @override
  void initState() {
    super.initState();
    Clipboard.getData(Clipboard.kTextPlain).then((data) {
      controller.text = data?.text ?? "";
    });

    // FlutterClipboard.paste().then((value) {
    //   controller.text = value;
    //   print(value);
    //   if (mounted) setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            autofocus: true,
            enabled: enable,
            minLines: 4,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "请在此粘贴文本,将由AI识别并提取任务信息。",
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
  }

  void bSend() async {
    if (controller.text.isEmpty) return;
    startSendTime = DateTime.now();
    setState(() {});

    final t = await Network.getTaskFromText(controller.text);
    if (t.length == 1) Get.to(EditTaskPage(old: t.first));

    startSendTime = null;
    setState(() {});
  }
}
