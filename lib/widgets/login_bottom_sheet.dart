import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:time_manager_client/helper/helper.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  static Future<int?> show(BuildContext context) => Helper.showModalBottomSheetWithTextField<int>(context, LoginBottomSheet());

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  Future<int?> getPhoneNumber() async {
    var p = await MobileNumber.hasPhonePermission;
    if (!p) {
      await MobileNumber.requestPhonePermission;
      p = await MobileNumber.hasPhonePermission;
      if (!p) {
        Get.back();
        Get.snackbar("权限申请失败", "请重新尝试登陆");
        return null;
      }
    }

    var s = await MobileNumber.mobileNumber;
    return Helper.formatPhoneNumber(s);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder(
        future: getPhoneNumber(),
        builder: (context, snapshot) {
          var phoneNumber = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 24),
                Text("欢迎用户", style: textTheme.titleLarge),
                const SizedBox(height: 32),
                if (phoneNumber == null) Text("请允许应用获取手机号码", style: textTheme.bodyLarge) else Text(phoneNumber.toString(), style: textTheme.displaySmall),
                const SizedBox(height: 24),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: phoneNumber == null ? null : () => Get.back(result: phoneNumber),
                    child: Text("登陆"),
                  ),
                ),
                Row(children: [Expanded(child: SizedBox())]),
                SizedBox(height: 24),
              ],
            ),
          );
        });
  }
}
