//
//  Generated code. Do not modify.
//  source: mindmap.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Mindmap extends $pb.GeneratedMessage {
  factory Mindmap({
    $core.Iterable<$fixnum.Int64>? taskIds,
    $core.String? mindmap,
  }) {
    final $result = create();
    if (taskIds != null) {
      $result.taskIds.addAll(taskIds);
    }
    if (mindmap != null) {
      $result.mindmap = mindmap;
    }
    return $result;
  }
  Mindmap._() : super();
  factory Mindmap.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Mindmap.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Mindmap', package: const $pb.PackageName(_omitMessageNames ? '' : 'time_manager'), createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'taskIds', $pb.PbFieldType.KU6, protoName: 'taskIds')
    ..aOS(2, _omitFieldNames ? '' : 'mindmap')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Mindmap clone() => Mindmap()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Mindmap copyWith(void Function(Mindmap) updates) => super.copyWith((message) => updates(message as Mindmap)) as Mindmap;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Mindmap create() => Mindmap._();
  Mindmap createEmptyInstance() => create();
  static $pb.PbList<Mindmap> createRepeated() => $pb.PbList<Mindmap>();
  @$core.pragma('dart2js:noInline')
  static Mindmap getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Mindmap>(create);
  static Mindmap? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$fixnum.Int64> get taskIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get mindmap => $_getSZ(1);
  @$pb.TagNumber(2)
  set mindmap($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMindmap() => $_has(1);
  @$pb.TagNumber(2)
  void clearMindmap() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
