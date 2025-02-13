import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
// import 'package:mobile_number/mobile_number.dart';
import 'package:time_manager_client/helper/helper.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  static Future<int?> show(BuildContext context) => Helper.showModalBottomSheetWithTextField<int>(context, LoginBottomSheet());

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  @override
  void initState() {
    super.initState();

    // MobileNumber.hasPhonePermission.then((isPermissionGranted) {
    //   if (!isPermissionGranted) {
    //     MobileNumber.requestPhonePermission.then((_) {});
    //     if (!isPermissionGranted) {
    //       Get.snackbar("错误", "无法获取手机信息");
    //       Get.back();
    //     }
    //   }
    // });
  }

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
          Text("12312341234", style: textTheme.displaySmall),
          const SizedBox(height: 24),
          SizedBox(
            width: 250,
            child: GFButton(
              onPressed: () {
                Get.back(result: 12312341234);
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
