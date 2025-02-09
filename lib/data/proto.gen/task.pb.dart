//
//  Generated code. Do not modify.
//  source: task.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Task extends $pb.GeneratedMessage {
  factory Task({
    $core.String? title,
    $core.String? summary,
    $fixnum.Int64? startTime,
    $core.int? startTimePrecision,
    $fixnum.Int64? endTime,
    $core.int? endTimePrecision,
    $core.int? importance,
    $core.String? location,
    $core.String? participant,
    $core.String? note,
    $core.String? source,
    $core.String? content,
    $core.int? status,
    $fixnum.Int64? updateTimestampAt,
  }) {
    final $result = create();
    if (title != null) {
      $result.title = title;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    if (startTime != null) {
      $result.startTime = startTime;
    }
    if (startTimePrecision != null) {
      $result.startTimePrecision = startTimePrecision;
    }
    if (endTime != null) {
      $result.endTime = endTime;
    }
    if (endTimePrecision != null) {
      $result.endTimePrecision = endTimePrecision;
    }
    if (importance != null) {
      $result.importance = importance;
    }
    if (location != null) {
      $result.location = location;
    }
    if (participant != null) {
      $result.participant = participant;
    }
    if (note != null) {
      $result.note = note;
    }
    if (source != null) {
      $result.source = source;
    }
    if (content != null) {
      $result.content = content;
    }
    if (status != null) {
      $result.status = status;
    }
    if (updateTimestampAt != null) {
      $result.updateTimestampAt = updateTimestampAt;
    }
    return $result;
  }
  Task._() : super();
  factory Task.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Task.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Task', package: const $pb.PackageName(_omitMessageNames ? '' : 'time_manager'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'summary')
    ..aInt64(3, _omitFieldNames ? '' : 'startTime', protoName: 'startTime')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'startTimePrecision', $pb.PbFieldType.O3, protoName: 'startTimePrecision')
    ..aInt64(5, _omitFieldNames ? '' : 'endTime', protoName: 'endTime')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'endTimePrecision', $pb.PbFieldType.O3, protoName: 'endTimePrecision')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'importance', $pb.PbFieldType.O3)
    ..aOS(8, _omitFieldNames ? '' : 'location')
    ..aOS(9, _omitFieldNames ? '' : 'participant')
    ..aOS(10, _omitFieldNames ? '' : 'note')
    ..aOS(11, _omitFieldNames ? '' : 'source')
    ..aOS(12, _omitFieldNames ? '' : 'content')
    ..a<$core.int>(13, _omitFieldNames ? '' : 'status', $pb.PbFieldType.O3)
    ..aInt64(100, _omitFieldNames ? '' : 'updateTimestampAt', protoName: 'updateTimestampAt')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Task clone() => Task()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Task copyWith(void Function(Task) updates) => super.copyWith((message) => updates(message as Task)) as Task;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Task create() => Task._();
  Task createEmptyInstance() => create();
  static $pb.PbList<Task> createRepeated() => $pb.PbList<Task>();
  @$core.pragma('dart2js:noInline')
  static Task getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Task>(create);
  static Task? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get summary => $_getSZ(1);
  @$pb.TagNumber(2)
  set summary($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearSummary() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get startTime => $_getI64(2);
  @$pb.TagNumber(3)
  set startTime($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStartTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get startTimePrecision => $_getIZ(3);
  @$pb.TagNumber(4)
  set startTimePrecision($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStartTimePrecision() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartTimePrecision() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get endTime => $_getI64(4);
  @$pb.TagNumber(5)
  set endTime($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEndTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearEndTime() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get endTimePrecision => $_getIZ(5);
  @$pb.TagNumber(6)
  set endTimePrecision($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasEndTimePrecision() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndTimePrecision() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get importance => $_getIZ(6);
  @$pb.TagNumber(7)
  set importance($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasImportance() => $_has(6);
  @$pb.TagNumber(7)
  void clearImportance() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get location => $_getSZ(7);
  @$pb.TagNumber(8)
  set location($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasLocation() => $_has(7);
  @$pb.TagNumber(8)
  void clearLocation() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get participant => $_getSZ(8);
  @$pb.TagNumber(9)
  set participant($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasParticipant() => $_has(8);
  @$pb.TagNumber(9)
  void clearParticipant() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get note => $_getSZ(9);
  @$pb.TagNumber(10)
  set note($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasNote() => $_has(9);
  @$pb.TagNumber(10)
  void clearNote() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get source => $_getSZ(10);
  @$pb.TagNumber(11)
  set source($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasSource() => $_has(10);
  @$pb.TagNumber(11)
  void clearSource() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get content => $_getSZ(11);
  @$pb.TagNumber(12)
  set content($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasContent() => $_has(11);
  @$pb.TagNumber(12)
  void clearContent() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get status => $_getIZ(12);
  @$pb.TagNumber(13)
  set status($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasStatus() => $_has(12);
  @$pb.TagNumber(13)
  void clearStatus() => clearField(13);

  @$pb.TagNumber(100)
  $fixnum.Int64 get updateTimestampAt => $_getI64(13);
  @$pb.TagNumber(100)
  set updateTimestampAt($fixnum.Int64 v) { $_setInt64(13, v); }
  @$pb.TagNumber(100)
  $core.bool hasUpdateTimestampAt() => $_has(13);
  @$pb.TagNumber(100)
  void clearUpdateTimestampAt() => clearField(100);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
