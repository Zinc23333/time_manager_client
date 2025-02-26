import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/repository/remote_db.dart';
import 'package:time_manager_client/pages/edit_task_page.dart';
import 'package:time_manager_client/widgets/multi_task_selector_bottom_sheet.dart';
import 'package:time_manager_client/widgets/waiting_dialog.dart';

class WebCrawlerPage extends StatelessWidget {
  const WebCrawlerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("网页爬虫导入"),
      ),
      body: FutureBuilder(
          future: RemoteDb.instance.getWebCrawlerWebs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final webs = snapshot.data!;
              return ListView.builder(
                itemCount: webs.length,
                itemBuilder: (context, index) {
                  final web = webs[index];
                  return ListTile(
                    title: Text(web.name),
                    subtitle: Text(web.summary),
                    onTap: () {
                      WaitingDialog(RemoteDb.instance.getWebCrawlerTasks(web.id)).show(context).then((ts) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (ts == null || ts.isEmpty) return;
                          MultiTaskSelectorBottomSheet(tasks: ts).show(context).then((t) {
                            if (t == null) return;
                            Get.to(() => EditTaskPage(old: t));
                          });
                        });
                      });
                      // final ts = await ;
                      // // if (mounted)
                      // WidgetsBinding.instance.addPostFrameCallback((d) {
                      //   MultiTaskSelectorBottomSheet(tasks: ts).show(context).then((t) {
                      //     if (t == null) return;
                      //     Get.to(() => EditTaskPage(old: t));
                      //   });
                      // });
                    },
                  );
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
