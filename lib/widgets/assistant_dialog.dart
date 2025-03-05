import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_manager_client/data/controller/data_controller.dart';

class AssistantDialog extends StatelessWidget {
  const AssistantDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Builder(builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Center(
          child: SizedBox(
            width: screenSize.width * 0.8,
            height: screenSize.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("助手", style: textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text("以下是为您规划的今天的行程。", style: textTheme.bodyMedium),
                const SizedBox(height: 16),
                Expanded(child: buildTasks())
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildTasks() {
    late final c = DataController.to;
    return Stack(
      children: [
        Positioned(
          left: 20,
          width: 2,
          top: 0,
          bottom: 0,
          child: VerticalDivider(),
        ),
      ],
    );
  }
}
