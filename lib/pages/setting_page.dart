import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/local_storage.dart';
import 'package:time_manager_client/helper/helper.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Color colorseed;

  @override
  void initState() {
    super.initState();

    final cs = Box.setting.read<String>("colorseed");
    colorseed = Helper.fromHexString(cs ?? "") ?? Colors.deepPurple;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildTileDarkmode(context),
        buildTileColorScheme(context),
      ],
    );
  }

  ListTile buildTileColorScheme(BuildContext context) {
    return ListTile(
      title: Text("颜色主题"),
      trailing: Icon(Icons.circle, color: Theme.of(context).colorScheme.inversePrimary),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("选择颜色"),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: colorseed,
                onColorChanged: (color) {
                  colorseed = color;
                  Box.setting.write("colorseed", color.toHexString());
                  Get.back();
                  for (final b in Brightness.values) {
                    Get.changeTheme(
                      ThemeData(
                        colorScheme: ColorScheme.fromSeed(seedColor: color, brightness: b),
                        useMaterial3: true,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  ListTile buildTileDarkmode(BuildContext context) {
    return ListTile(
      title: Text("色彩模式"),
      trailing: Get.isDarkMode ? Icon(Icons.mode_night) : Icon(Icons.light_mode),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text("浅色模式"),
                onPressed: () {
                  Get.changeThemeMode(ThemeMode.light);
                  Box.setting.write("darkmode", false);
                  Get.back();
                },
              ),
              SimpleDialogOption(
                child: Text("深色模式"),
                onPressed: () {
                  Get.changeThemeMode(ThemeMode.dark);
                  Box.setting.write("darkmode", true);
                  Get.back();
                },
              ),
              SimpleDialogOption(
                child: Text("跟随系统"),
                onPressed: () {
                  Get.changeThemeMode(ThemeMode.dark);
                  Box.setting.remove("darkmode");
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
