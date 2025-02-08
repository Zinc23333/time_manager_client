import 'package:flutter/material.dart';
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
    Text("2"),
    Text("3"),
    Text("4"),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("时间助手"),
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

  void _addTask() {
    AddTaskWidget.show(context);
  }
}
