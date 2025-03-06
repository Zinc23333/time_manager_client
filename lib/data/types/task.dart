import 'dart:convert';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:time_manager_client/data/repository/logger.dart';
import 'package:time_manager_client/data/types/ts_data.dart';
import 'package:time_manager_client/data/types/type.dart';
import 'package:time_manager_client/helper/coordinate_helper.dart';
import 'package:time_manager_client/helper/extension.dart';
import 'package:time_manager_client/data/proto.gen/task.pb.dart' as p;
import 'package:time_manager_client/helper/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class Task extends TsData {
  String title;
  String? summary;

  DateTime? startTime;
  int? startTimePrecision;
  DateTime? endTime;
  int? endTimePrecision;

  int? importance;
  String? location;
  String? participant;
  String? note;
  String? source;
  String? content;
  TaskStatus status;

  List<DateTime> noticeTimes;
  List<String> tags;
  LatLng? latLng;

  Task(
      {required this.title,
      this.summary,
      this.startTime,
      this.startTimePrecision,
      this.endTime,
      this.endTimePrecision,
      this.importance,
      this.location,
      this.participant,
      this.note,
      this.source,
      this.content,
      this.status = TaskStatus.unfinished,
      List<DateTime>? noticeTimes,
      List<String>? tags,
      this.latLng,
      int? updateTimestampAt})
      : noticeTimes = noticeTimes ?? <DateTime>[],
        tags = tags ?? <String>[],
        super(updateTimestampAt) {
    init();
  }

  Task.delete()
      : title = "",
        status = TaskStatus.finished,
        noticeTimes = const [],
        tags = const [];

  Task.loading()
      : title = "",
        status = TaskStatus.finished,
        noticeTimes = const [],
        tags = const [];

  Task.fromController(
    List<TextEditingController> controllers, {
    this.startTime,
    this.startTimePrecision,
    this.endTime,
    this.endTimePrecision,
    this.importance,
    this.content,
    this.noticeTimes = const [],
    this.tags = const [],
    this.status = TaskStatus.unfinished,
  })  : assert(controllers.length == 6),
        title = controllers[0].text,
        summary = controllers[1].text,
        location = controllers[2].text,
        participant = controllers[3].text,
        note = controllers[4].text,
        source = controllers[5].text {
    init();
  }

  Task.importFromAiMap(
    Map map, [
    this.status = TaskStatus.unfinished,
    this.source = "自动识别",
  ])  : title = map["title"],
        summary = map["summary"],
        startTime = map["startTime"] == null ? null : DateTime.fromMillisecondsSinceEpoch(map["startTime"] * 1000),
        startTimePrecision = map["startTimePrecision"],
        endTime = map["endTime"] == null ? null : DateTime.fromMillisecondsSinceEpoch(map["endTime"] * 1000),
        endTimePrecision = map["endTimePrecision"],
        importance = map["importance"],
        location = map["location"],
        participant = map["participant"],
        note = map["note"],
        noticeTimes = <DateTime>[
          for (final e in map["noticeTimes"] ?? []) DateTime.fromMillisecondsSinceEpoch(e * 1000),
        ],
        tags = map["tags"]?.cast<String>() ?? <String>[] {
    init();
  }

  Task.fromMap(Map<String, dynamic> map)
      : title = map["title"],
        summary = map["summary"],
        startTime = map["startTime"] == null ? null : DateTime.fromMillisecondsSinceEpoch(map["startTime"]),
        startTimePrecision = map["startTimePrecision"],
        endTime = map["endTime"] == null ? null : DateTime.fromMillisecondsSinceEpoch(map["endTime"]),
        endTimePrecision = map["endTimePrecision"],
        importance = map["importance"],
        location = map["location"],
        participant = map["participant"],
        note = map["note"],
        source = map["source"],
        content = map["content"],
        status = TaskStatus.fromCode(map["status"] ?? 1),
        noticeTimes = <DateTime>[
          for (final e in map["noticeTimes"] ?? []) DateTime.fromMillisecondsSinceEpoch(e),
        ],
        tags = map["tags"]?.cast<String>() ?? <String>[],
        latLng = (map["lat"] != null && map["lng"] != null) ? (map["lat"], map["lng"]) : null;

  static Task? fromMapNullable(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty || !map.containsKey("title")) return null;
    return Task.fromMap(map);
  }

  static List<Task> fromJsonString(String text) {
    final List<Task> res = [];
    final jl = jsonDecode(text);
    if (jl is List) {
      for (final j in jl) {
        if (j is Map) {
          j.containsKey("title");
          final r = Task.importFromAiMap(j);
          res.add(r);
        }
      }
    }
    return res;
  }

  factory Task.fromProto(p.Task t) => Task(
        title: t.title,
        summary: Helper.if_(t.hasSummary(), t.summary),
        startTime: Helper.if_(t.hasStartTime(), t.startTime.toDateTime()),
        startTimePrecision: Helper.if_(t.hasStartTimePrecision(), t.startTimePrecision),
        endTime: Helper.if_(t.hasEndTime(), t.endTime.toDateTime()),
        endTimePrecision: Helper.if_(t.hasEndTimePrecision(), t.endTimePrecision),
        importance: Helper.if_(t.hasImportance(), t.importance),
        location: Helper.if_(t.hasLocation(), t.location),
        participant: Helper.if_(t.hasParticipant(), t.participant),
        note: Helper.if_(t.hasNote(), t.note),
        source: Helper.if_(t.hasSource(), t.source),
        content: Helper.if_(t.hasContent(), t.content),
        status: TaskStatus.fromCode(t.status),
        noticeTimes: t.noticeTimes.map((e) => e.toDateTime()).toList(),
        updateTimestampAt: t.updateTimestampAt.toInt(),
        tags: t.tags,
        latLng: Helper.if_(t.hasLat() && t.hasLng(), (t.lat, t.lng)),
      );

  // factory Task.fromUint8List(Uint8List data) => Task.fromProto(p.Task.fromBuffer(data));

  void init() {
    if (startTime != null) startTimePrecision ??= 5;
    if (endTime != null) endTimePrecision ??= 5;
    if (importance != null && (importance! <= 0 || importance! > 5)) importance = null;
    if (title.isEmpty) throw ArgumentError("title cannot be empty");
  }

  String getState() {
    if (startTime == null) return status.name;
    if (status == TaskStatus.finished) return "已完成";

    final now = DateTime.now();
    if (now.isBefore(startTime!)) return "未开始";
    if (endTime == null || now.isBefore(endTime!)) return "进行中";
    return "已过期";
  }

  String get startTimeWithPrecision => startTime?.formatWithPrecision(startTimePrecision ?? 5) ?? "";
  String get endTimeWithPrecision => endTime?.formatWithPrecision(endTimePrecision ?? 5) ?? "";

  @override
  bool get isDeleted => title.isEmpty;
  // @override
  bool get isLoading => title.isEmpty && updateTimestampAt == -1;
  @override
  String get tableName => "tasks";

  @override
  Map<String, dynamic> toMap() => {
        "title": title,
        "summary": summary,
        "startTime": startTime?.millisecondsSinceEpoch,
        "startTimePrecision": startTimePrecision,
        "endTime": endTime?.millisecondsSinceEpoch,
        "endTimePrecision": endTimePrecision,
        "importance": importance,
        "location": location,
        "participant": participant,
        "note": note,
        "source": source,
        "content": content,
        "status": status.code,
        "noticeTimes": noticeTimes.map((e) => e.millisecondsSinceEpoch).toList(),
        "tags": tags,
        "lat": latLng?.$1,
        "lng": latLng?.$2,
      };

  String toJsonString() => JsonEncoder().convert(toMap());

  static const List<(String label, IconData icon, bool nullable)> inputFieldParams = [
    ("标题", Icons.flag_outlined, false),
    ("概述", Icons.label_outlined, true),
    ("地点", Icons.location_on_outlined, true),
    ("参与者", Icons.people_alt_outlined, true),
    ("备注", Icons.note_outlined, true),
    ("来源", Icons.source_outlined, true),
  ];

  List<(String label, IconData icon, String?, void Function()?)> paramAndInfo() => [
        ("标题", Icons.flag_outlined, title, null),
        ("概述", Icons.label_outline, summary, null),
        ("地点", Icons.location_on_outlined, location, onLocationClick),
        ("参与者", Icons.people_alt_outlined, participant, null),
        ("备注", Icons.note_outlined, note, null),
        ("来源", Icons.source_outlined, source, null),
      ];

  // 地点点击事件
  final _deviceLocation = Location();
  void onLocationClick() async {
    if ((await _deviceLocation.hasPermission()) == PermissionStatus.denied) {
      await _deviceLocation.requestPermission();
    }

    if (await _deviceLocation.hasPermission() == PermissionStatus.denied || await _deviceLocation.hasPermission() == PermissionStatus.deniedForever) return;
    final loc = await _deviceLocation.getLocation();
    if (loc.latitude == null || loc.longitude == null) return;
    final latLng = CoordinateHelper.wgs84ToGcj02(loc.latitude!, loc.longitude!);
    logger.d(latLng);

    final us = [
      "androidamap://arroundpoi?sourceApplication=softname&keywords=$location&lat=${latLng.$1}&lon=${latLng.$2}&dev=0",
      "https://uri.amap.com/search?keyword=$location&amp;&center=${latLng.$2},${latLng.$1}&amp;&view=map&amp;&callnative=1&amp",
    ];
    for (final u in us) {
      final r = Uri.parse(u);
      final s = await launchUrl(r);
      if (s) break;
    }
  }

  // 日程点击事件
  void onDateTimeClick() async {
    if (startTime == null) return;
    final Event event = Event(
      title: title,
      description: summary,
      location: location,
      startDate: startTime!,
      endDate: endTime ?? startTime!,
    );
    await Add2Calendar.addEvent2Cal(event);
  }

  void onNoticeTimeClick() async {}

  bool contain(String text) =>
      title.contains(text) ||
      (summary?.contains(text) ?? false) ||
      (location?.contains(text) ?? false) ||
      (participant?.contains(text) ?? false) ||
      (note?.contains(text) ?? false) ||
      (source?.contains(text) ?? false) ||
      (startTime?.toIso8601String().contains(text) ?? false) ||
      (endTime?.toIso8601String().contains(text) ?? false);

  @override
  String toString() => "Task($title, $summary, $startTime($startTimePrecision), $endTime($endTimePrecision))";

  @override
  p.Task toProto() => p.Task(
        title: title,
        summary: summary,
        startTime: startTime?.millisecondsSinceEpoch.toInt64(),
        startTimePrecision: startTimePrecision,
        endTime: endTime?.millisecondsSinceEpoch.toInt64(),
        endTimePrecision: endTimePrecision,
        importance: importance,
        location: location,
        participant: participant,
        note: note,
        source: source,
        content: content,
        status: status.code,
        noticeTimes: noticeTimes.map((e) => e.millisecondsSinceEpoch.toInt64()),
        tags: tags,
        updateTimestampAt: updateTimestampAt.toInt64(),
        lat: latLng?.$1,
        lng: latLng?.$2,
      );

  static const importanceInfo = ["未设置", "不重要", "较不重要", "一般", "重要", "非常重要"];
  static const timePricisions = "年月日时分秒";
  static const defaultTags = ['工作', '个人', '学习', '健康', '财务', '社交', '旅行', '家庭', '创意'];
  static const defaultTagIcons = [
    Icons.work,
    Icons.person,
    Icons.school,
    Icons.favorite,
    Icons.attach_money,
    Icons.people,
    Icons.flight,
    Icons.home,
    Icons.color_lens
  ];
}

enum TaskStatus {
  unfinished(1, "未完成"),
  finished(2, "已完成"),
  ;

  const TaskStatus(this.code, this.name);

  final int code;
  final String name;
  bool get isFinished => this == finished;
  static TaskStatus fromCode(int code) {
    return TaskStatus.values.firstWhereOrNull((e) => e.code == code) ?? unfinished;
  }
}
