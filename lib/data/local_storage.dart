import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_manager_client/data/proto.gen/storage.pb.dart' as p;
import 'package:time_manager_client/data/types/group.dart';
import 'package:time_manager_client/data/types/task.dart';

class Box {
  static String settingKey = "Get-Settings";
  static GetStorage setting = GetStorage(settingKey);
}

class LocalStorage {
  LocalStorage._();
  static final LocalStorage _instance = LocalStorage._();
  static LocalStorage? get instance => kIsWeb ? null : _instance;
  static const storageFileName = "storage.bin";

  bool _initialized = false;
  late final Directory storageDir;
  late final File storageFile;

  Future<void> init() async {
    if (_initialized) return;
    storageDir = await getApplicationDocumentsDirectory();
    storageFile = File("${storageDir.path}/$storageFileName");

    _initialized = true;
  }

  // 写出
  void write(p.Storage storage) {
    storageFile.writeAsBytesSync(storage.writeToBuffer());
  }

  // 导出
  Future<File?> writeTo(p.Storage storage, String path) async {
    if (kIsWeb) return null;
    write(storage);
    return await storageFile.copy(path);
  }

  Future<File?> writeToDownloadDirectory(p.Storage storage) async {
    if (kIsWeb) return null;

    final d = await getDownloadsDirectory();
    if (d == null) return null;
    if (!d.existsSync()) return null;

    return await writeTo(storage, "${d.path}/待办备份 ${DateTime.now()}.bin");
  }

  // 导入
  (Map<int, Group> groups, Map<int, Task> tasks, List<int> groupIds, int currentGroup)? read([Uint8List? rawData]) {
    final Map<int, Group> g = {};
    final Map<int, Task> t = {};
    final List<int> gis = [];

    if (rawData == null && !storageFile.existsSync()) return null;

    rawData ??= storageFile.readAsBytesSync();
    final s = p.Storage.fromBuffer(rawData);

    s.groups.forEach((key, value) {
      g[key.toInt()] = Group.fromProto(value);
    });

    s.tasks.forEach((key, value) {
      t[key.toInt()] = Task.fromProto(value);
    });

    for (var element in s.groupIds) {
      gis.add(element.toInt());
    }

    return (g, t, gis, s.currentGroupId.toInt());
  }
}
