import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/controller.dart';
import 'package:time_manager_client/helper/helper.dart';
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
    (Icons.list, "列表", ListPage()),
    (Icons.dangerous, "四象限", FourQuadrantPage()),
    (Icons.calendar_month, "日历", Text("4")),
    (Icons.settings, "设置", SettingPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: buildGroupSwitcher(),
            centerTitle: true,
          ),
          bottomNavigationBar: Helper.if_(isPortrait, buildBottomNavigationBar()),
          floatingActionButton: FloatingActionButton(
            onPressed: _addTask,
            tooltip: "添加",
            shape: CircleBorder(),
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: Helper.if_(isPortrait, FloatingActionButtonLocation.centerDocked),
          body: buildBody(orientation),
        );
      },
    );
  }

  Widget buildBody(Orientation orientation) => orientation == Orientation.landscape
      ? Row(
          children: [
            SizedBox(
              width: 250,
              child: Column(
                children: [
                  for (int i = 0; i < pages.length; i++)
                    ListTile(
                      leading: Icon(pages[i].$1),
                      title: Text(pages[i].$2),
                      onTap: () {
                        _currentIndex = i;
                        setState(() {});
                      },
                    )
                ],
              ),
            ),
            VerticalDivider(),
            Expanded(child: pages[_currentIndex].$3),
          ],
        )
      : pages[_currentIndex].$3;

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      // landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 2) return;
        if (index > 2) index--;

        _currentIndex = index;
        setState(() {});
      },
      items: [
        for (int i = 0; i < pages.length; i++)
          BottomNavigationBarItem(
            icon: Icon(pages[i].$1),
            label: pages[i].$2,
          ),
      ]..insert(2, BottomNavigationBarItem(icon: SizedBox(), label: "")),
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
              Text(Controller.to.currentGroup.icon),
              const SizedBox(width: 4),
              Text(Controller.to.currentGroup.title),
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
              if (group == Controller.to.currentGroup)
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
