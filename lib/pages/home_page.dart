import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/controller.dart';
import 'package:time_manager_client/pages/edit_group_page.dart';
import 'package:time_manager_client/pages/four_quadrant_page.dart';
import 'package:time_manager_client/pages/list_page.dart';
import 'package:time_manager_client/pages/setting_page.dart';
import 'package:time_manager_client/widgets/add_task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final pages = [
    ListPage(),
    FourQuadrantPage(),
    Text("3"),
    Text("4"),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: buildGroupSwitcher(),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) return;
          _currentIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "列表"),
          BottomNavigationBarItem(icon: Icon(Icons.dangerous), label: "四象限"),
          BottomNavigationBarItem(icon: SizedBox(), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "日历"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "设置"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: "添加",
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: pages[_currentIndex],
    );
  }

  Widget buildGroupSwitcher() {
    return InkWell(
      onTap: bSwitchGroup,
      child: GetBuilder<Controller>(
        builder: (_) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Controller.to.currentGroup.value.icon),
              const SizedBox(width: 4),
              Text(Controller.to.currentGroup.value.title),
              const SizedBox(width: 4),
              Icon(Icons.arrow_drop_down_rounded),
            ],
          );
        },
      ),
    );
  }

  void bSwitchGroup() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("选择分组"),
          children: [
            for (final group in Controller.to.groups)
              if (group == Controller.to.currentGroup.value)
                SimpleDialogOption(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: group.iconAndTitle),
                    TextSpan(text: "  "),
                    TextSpan(text: "[当前]", style: TextStyle(color: Colors.green)),
                  ])),
                )
              else
                SimpleDialogOption(
                  onPressed: () {
                    Controller.to.changeCurrentGroup(group);
                    Get.back();
                  },
                  child: Text(group.iconAndTitle),
                ),
            SimpleDialogOption(
              onPressed: () {
                Get.off(EditGroupPage());
              },
              child: Text("编辑分组"),
            )
          ],
        );
      },
    );
  }

  void _addTask() {
    AddTaskWidget.show(context);
  }
}
