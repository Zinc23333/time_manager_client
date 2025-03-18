import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/controller/data_controller.dart';

class UserPromptPage extends StatefulWidget {
  const UserPromptPage({super.key});

  // final List<String> prompts;

  @override
  State<UserPromptPage> createState() => _UserPromptPageState();
}

class _UserPromptPageState extends State<UserPromptPage> {
  // late List<TextEditingController> controllers = widget.prompts.map((p) => TextEditingController(text: p)).toList();
  List<TextEditingController> controllers = [];

  Iterable<TextField> get textFields => List.generate(
        controllers.length,
        (index) => TextField(
          controller: controllers[index],
          decoration: InputDecoration(
            labelText: "用户提示词${index + 1}",
            suffixIcon: IconButton(
              onPressed: () {
                controllers.removeAt(index);
                setState(() {});
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();

    DataController.to.getUserPrompt(true).then((prompts) {
      if (prompts.isEmpty) return;
      controllers = prompts.map((e) => TextEditingController(text: e)).toList();
      if (mounted) setState(() {});
    });
  }

  final userCareers = [
    ("学生", "🧑‍🎓"),
    ("老师", "🧑‍🏫"),
    ("医生", "🧑‍⚕️"),
    ("其他", "🧑‍💼"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("用户提示词"),
        actions: [
          IconButton(
            onPressed: () async {
              await DataController.to.updateUserPrompt(controllers.map((e) => e.text));
              Get.back();
            },
            icon: Icon(Icons.save_rounded),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text("用户身份:", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 128, child: Row(children: userCareers.map((e) => IconButton(onPressed: () {}, icon: Text(e.$2))).toList())),
              ...textFields,
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  controllers.add(TextEditingController());
                  setState(() {});
                },
                label: Text("添加用户提示词"),
                icon: Icon(Icons.add),
              ),
              Text.rich(TextSpan(children: [
                WidgetSpan(child: Icon(Icons.info_outline_rounded, color: Colors.grey)),
                TextSpan(text: "设置适当的用户提示词，在识别文本信息时，更加符合你的需求", style: TextStyle(color: Colors.grey)),
              ])),
            ],
          ),
        ),
      ),
    );
  }
}
