import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getwidget/getwidget.dart';
import 'package:time_manager_client/helper/helper.dart';

class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet({super.key});

  static Future<int?> show(BuildContext context) => Helper.showModalBottomSheetWithTextField<int>(context, LoginBottomSheet());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 24),
          Text("欢迎用户", style: textTheme.titleLarge),
          const SizedBox(height: 32),
          Text("18862943692", style: textTheme.displaySmall),
          const SizedBox(height: 24),
          SizedBox(
            width: 250,
            child: GFButton(
              onPressed: () {
                Get.back(result: 18862943692);
              },
              color: Theme.of(context).colorScheme.inversePrimary,
              shape: GFButtonShape.pills,
              fullWidthButton: true,
              child: Text("登陆"),
            ),
          ),
          Row(children: [Expanded(child: SizedBox())]),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
