import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:time_manager_client/data/controller.dart';
import 'package:time_manager_client/data/local_storage.dart';
import 'package:time_manager_client/helper/helper.dart';
import 'package:time_manager_client/pages/home_page.dart';

void main() async {
  await GetStorage.init(Box.settingKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static bool? _themeMode;
  static Color? _colorSeed;

  @override
  Widget build(BuildContext context) {
    _themeMode = Box.setting.read<bool>("darkmode");
    _colorSeed = Helper.fromHexString(Box.setting.read<String>("colorseed") ?? "");

    return GetMaterialApp(
      onInit: () {
        Get.put(Controller());
      },
      title: '时间助手',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _colorSeed ?? Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _colorSeed ?? Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: _themeMode == null ? ThemeMode.system : (_themeMode! ? ThemeMode.dark : ThemeMode.light),
      locale: Locale("zh", "CN"),
      supportedLocales: [
        Locale("zh", "CN"),
        Locale("en", "US"),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomePage(),
    );
  }
}
