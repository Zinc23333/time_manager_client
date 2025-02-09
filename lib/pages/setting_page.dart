import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/controller.dart';
import 'package:time_manager_client/data/local_storage.dart';
import 'package:time_manager_client/helper/helper.dart';
import 'package:time_manager_client/widgets/simple_text_bottom_sheet.dart';

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
        buildTileExportToFile(context),
        buildTileExportAsText(context),
        buildTileImportFromText(context),
      ],
    );
  }

  ListTile buildTileImportFromText(BuildContext context) {
    return ListTile(
      title: Text("从文字导入"),
      onTap: () async {
        final s = await SimpleTextBottomSheet.show(context);
        if (s?.isEmpty ?? true) {
          Get.snackbar("导入失败", "文本为空");
          return;
        }

        if (Controller.to.loadFromText(s!)) {
          Get.snackbar("导入成功", "数据已导入");
        } else {
          Get.snackbar("导入失败", "数据格式错误");
        }
        // File? file = await Controller.to.saveDownloadDirectory();
        // if (file == null) {
        //   Get.snackbar("导出失败", "请检查是否有下载文件夹的写入权限");
        //   return;
        // }
        // Get.snackbar("导出成功", "已保存到: ${file.path}");
      },
    );
  }

  ListTile buildTileExportToFile(BuildContext context) {
    return ListTile(
      title: Text("导出数据到文件"),
      onTap: () async {
        File? file = await Controller.to.saveDownloadDirectory();
        if (file == null) {
          Get.snackbar("导出失败", "请检查是否有下载文件夹的写入权限");
          return;
        }
        Get.snackbar("导出成功", "已保存到: ${file.path}");
      },
    );
  }

  ListTile buildTileExportAsText(BuildContext context) {
    return ListTile(
      title: Text("导出数据为文本"),
      onTap: () async {
        String data = Controller.to.saveAsText();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("数据信息"),
            content: SingleChildScrollView(
              child: SelectableText(data),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: data));
                },
                child: Text("复制"),
              ),
            ],
          ),
        );
      },
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
                  Get.changeThemeMode(ThemeMode.system);
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
