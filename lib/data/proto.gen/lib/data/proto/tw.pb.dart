//
//  Generated code. Do not modify.
//  source: lib/data/proto/tw.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'group.pb.dart' as $1;
import 'task.pb.dart' as $0;

enum Tw_Data {
  task, 
  group, 
  notSet
}

class Tw extends $pb.GeneratedMessage {
  factory Tw({
    $fixnum.Int64? timestamp,
    $0.Task? task,
    $1.Group? group,
  }) {
    final $result = create();
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (task != null) {
      $result.task = task;
    }
    if (group != null) {
      $result.group = group;
    }
    return $result;
  }
  Tw._() : super();
  factory Tw.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Tw.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Tw_Data> _Tw_DataByTag = {
    2 : Tw_Data.task,
    3 : Tw_Data.group,
    0 : Tw_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Tw', createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aInt64(1, _omitFieldNames ? '' : 'timestamp')
    ..aOM<$0.Task>(2, _omitFieldNames ? '' : 'task', subBuilder: $0.Task.create)
    ..aOM<$1.Group>(3, _omitFieldNames ? '' : 'group', subBuilder: $1.Group.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Tw clone() => Tw()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Tw copyWith(void Function(Tw) updates) => super.copyWith((message) => updates(message as Tw)) as Tw;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tw create() => Tw._();
  Tw createEmptyInstance() => create();
  static $pb.PbList<Tw> createRepeated() => $pb.PbList<Tw>();
  @$core.pragma('dart2js:noInline')
  static Tw getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tw>(create);
  static Tw? _defaultInstance;

  Tw_Data whichData() => _Tw_DataByTag[$_whichOneof(0)]!;
  void clearData() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => clearField(1);

  @$pb.TagNumber(2)
  $0.Task get task => $_getN(1);
  @$pb.TagNumber(2)
  set task($0.Task v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTask() => $_has(1);
  @$pb.TagNumber(2)
  void clearTask() => clearField(2);
  @$pb.TagNumber(2)
  $0.Task ensureTask() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Group get group => $_getN(2);
  @$pb.TagNumber(3)
  set group($1.Group v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasGroup() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroup() => clearField(3);
  @$pb.TagNumber(3)
  $1.Group ensureGroup() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
