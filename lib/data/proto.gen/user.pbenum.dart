//
//  Generated code. Do not modify.
//  source: user.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class UserAccountType extends $pb.ProtobufEnum {
  static const UserAccountType UNKNOWN = UserAccountType._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const UserAccountType PHONE = UserAccountType._(1, _omitEnumNames ? '' : 'PHONE');

  static const $core.List<UserAccountType> values = <UserAccountType> [
    UNKNOWN,
    PHONE,
  ];

  static final $core.Map<$core.int, UserAccountType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserAccountType? valueOf($core.int value) => _byValue[value];

  const UserAccountType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
