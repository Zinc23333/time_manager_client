import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_manager_client/data/repository/logger.dart';
import 'package:time_manager_client/data/repository/remote_db.dart';

import 'package:time_manager_client/pages/web_crawler_add_page.dart';
import 'package:time_manager_client/widgets/pages/waiting_dialog.dart';
import 'package:time_manager_client/widgets/pages/web_crawler_tasks_bottom_sheet.dart';

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
                        });
                      }, onError: (t) {
                        logger.e(t);
                      });
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
