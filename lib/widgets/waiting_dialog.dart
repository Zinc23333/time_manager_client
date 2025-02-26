import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaitingDialog<T> extends StatelessWidget {
  const WaitingDialog(this.future, {super.key});

  final Future<T> future;

  Future<T?> show(BuildContext context) => showDialog<T>(
        context: context,
        builder: (context) => this,
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("加载中..."),
      content: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.back(result: snapshot.data);
              });
            }
            return SizedBox(
              height: 64,
              child: Center(child: CircularProgressIndicator()),
            );
          }),
    );
  }
}
