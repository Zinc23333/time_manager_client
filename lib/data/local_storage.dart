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

  bool _initialized = false;
  late final Directory storageDir;
  late final File storageFile;

  Future<void> init() async {
    if (_initialized) return;
    storageDir = await getApplicationDocumentsDirectory();
    storageFile = File("${storageDir.path}/storage.proto");

    _initialized = true;
  }

  void write(p.Storage storage) {
    storageFile.writeAsBytesSync(storage.writeToBuffer());
  }

  (Map<int, Group> groups, Map<int, Task> tasks, List<int> groupIds, int currentGroup)? read() {
    final Map<int, Group> g = {};
    final Map<int, Task> t = {};
    final List<int> gis = [];

    if (!storageFile.existsSync()) return null;

    final raw = storageFile.readAsBytesSync();
    final s = p.Storage.fromBuffer(raw);

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
