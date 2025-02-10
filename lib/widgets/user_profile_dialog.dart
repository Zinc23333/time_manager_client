import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/controller/data_controller.dart';
import 'package:time_manager_client/data/controller/user_controller.dart';

class UserProfileDialog extends StatelessWidget {
  const UserProfileDialog({super.key});

  static Future show(BuildContext context) => showDialog(
        context: context,
        builder: (context) => const UserProfileDialog(),
      );

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(child: Text(User.icon)),
              title: Text("用户 ${User.id}"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            for (final a in User.accounts)
              ListTile(
                leading: Icon(a.icon),
                title: Text(a.account),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    DataController.to.logout();
                    Get.back();
                  },
                  child: Text("退出登录"),
                ),
              ],
            ),
          ],
        ),
      );
}
