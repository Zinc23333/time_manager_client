import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/repository/logger.dart';
import 'package:time_manager_client/data/repository/remote_db.dart';

import 'package:time_manager_client/pages/web_crawler_add_page.dart';
import 'package:time_manager_client/widgets/waiting_dialog.dart';
import 'package:time_manager_client/widgets/web_crawler_tasks_bottom_sheet.dart';

class WebCrawlerPage extends StatelessWidget {
  const WebCrawlerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("网页爬虫导入"),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => WebCrawlerAddPage());
              },
              icon: Icon(Icons.add))
        ],
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
                      WaitingDialog(RemoteDb.instance.getWebCrawlerTasks(web.id)).show(context).then((wt) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          logger.d("OK");
                          if (wt == null || wt.isEmpty) return;
                          logger.d(wt);
                          WebCrawlerTasksBottomSheet(web, wt).show(context);

                          // MultiTaskSelectorBottomSheet(
                          //   tasks: ts,
                          //   title: web.name,
                          //   subTitle: web.summary,
                          //   info: "更新时间: ${web.lastCrawl.formatWithPrecision(5)}",
                          // ).show(context).then((t) {
                          //   if (t == null) return;
                          //   Get.to(() => EditTaskPage(old: t));
                          // });
                        });
                      }, onError: (t) {
                        logger.e(t);
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
