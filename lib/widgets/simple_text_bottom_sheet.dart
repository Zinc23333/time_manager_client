import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/helper/helper.dart';

class SimpleTextBottomSheet extends StatelessWidget {
  SimpleTextBottomSheet({super.key});

  static Future<String?> show(BuildContext context) => Helper.showModalBottomSheetWithTextField<String>(context, SimpleTextBottomSheet());
  final c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: c,
            maxLines: null,
            minLines: 4,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Get.back(result: c.text);
              },
              icon: Icon(Icons.send_rounded),
            ),
          ],
        )
      ],
    );
  }
}
