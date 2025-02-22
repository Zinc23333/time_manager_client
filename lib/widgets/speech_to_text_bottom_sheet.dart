import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:time_manager_client/data/repository/logger.dart';

class SpeechToTextBottomSheet extends StatefulWidget {
  const SpeechToTextBottomSheet({super.key});

  @override
  State<SpeechToTextBottomSheet> createState() => _SpeechToTextBottomSheetState();
}

class _SpeechToTextBottomSheetState extends State<SpeechToTextBottomSheet> {
  String t = "";
  bool listened = false;
  final stt = SpeechToText();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: stt.initialize(),
      builder: (context, snapshotInit) {
        if (snapshotInit.data == true) {
          if (!listened) {
            listened = true;
            stt.listen(
              onResult: (result) {
                logger.t(result.recognizedWords);
                Get.back(result: result.recognizedWords);
              },
            );
          }
          return Column(
            children: [
              Text(t),
              ElevatedButton(
                onPressed: () {
                  stt.stop();
                },
                child: Text("完成"),
              ),
            ],
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
