//
//  Generated code. Do not modify.
//  source: lib/data/proto/task.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use taskDescriptor instead')
const Task$json = {
  '1': 'Task',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'summary', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'summary', '17': true},
    {'1': 'startTime', '3': 3, '4': 1, '5': 3, '9': 1, '10': 'startTime', '17': true},
    {'1': 'startTimePrecision', '3': 4, '4': 1, '5': 5, '9': 2, '10': 'startTimePrecision', '17': true},
    {'1': 'endTime', '3': 5, '4': 1, '5': 3, '9': 3, '10': 'endTime', '17': true},
    {'1': 'endTimePrecision', '3': 6, '4': 1, '5': 5, '9': 4, '10': 'endTimePrecision', '17': true},
    {'1': 'importance', '3': 7, '4': 1, '5': 5, '9': 5, '10': 'importance', '17': true},
    {'1': 'location', '3': 8, '4': 1, '5': 9, '9': 6, '10': 'location', '17': true},
    {'1': 'participant', '3': 9, '4': 1, '5': 9, '9': 7, '10': 'participant', '17': true},
    {'1': 'note', '3': 10, '4': 1, '5': 9, '9': 8, '10': 'note', '17': true},
    {'1': 'source', '3': 11, '4': 1, '5': 9, '9': 9, '10': 'source', '17': true},
    {'1': 'content', '3': 12, '4': 1, '5': 9, '9': 10, '10': 'content', '17': true},
    {'1': 'status', '3': 13, '4': 1, '5': 5, '9': 11, '10': 'status', '17': true},
  ],
  '8': [
    {'1': '_summary'},
    {'1': '_startTime'},
    {'1': '_startTimePrecision'},
    {'1': '_endTime'},
    {'1': '_endTimePrecision'},
    {'1': '_importance'},
    {'1': '_location'},
    {'1': '_participant'},
    {'1': '_note'},
    {'1': '_source'},
    {'1': '_content'},
    {'1': '_status'},
  ],
};

/// Descriptor for `Task`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskDescriptor = $convert.base64Decode(
    'CgRUYXNrEhQKBXRpdGxlGAEgASgJUgV0aXRsZRIdCgdzdW1tYXJ5GAIgASgJSABSB3N1bW1hcn'
    'mIAQESIQoJc3RhcnRUaW1lGAMgASgDSAFSCXN0YXJ0VGltZYgBARIzChJzdGFydFRpbWVQcmVj'
    'aXNpb24YBCABKAVIAlISc3RhcnRUaW1lUHJlY2lzaW9uiAEBEh0KB2VuZFRpbWUYBSABKANIA1'
    'IHZW5kVGltZYgBARIvChBlbmRUaW1lUHJlY2lzaW9uGAYgASgFSARSEGVuZFRpbWVQcmVjaXNp'
    'b26IAQESIwoKaW1wb3J0YW5jZRgHIAEoBUgFUgppbXBvcnRhbmNliAEBEh8KCGxvY2F0aW9uGA'
    'ggASgJSAZSCGxvY2F0aW9uiAEBEiUKC3BhcnRpY2lwYW50GAkgASgJSAdSC3BhcnRpY2lwYW50'
    'iAEBEhcKBG5vdGUYCiABKAlICFIEbm90ZYgBARIbCgZzb3VyY2UYCyABKAlICVIGc291cmNliA'
    'EBEh0KB2NvbnRlbnQYDCABKAlIClIHY29udGVudIgBARIbCgZzdGF0dXMYDSABKAVIC1IGc3Rh'
    'dHVziAEBQgoKCF9zdW1tYXJ5QgwKCl9zdGFydFRpbWVCFQoTX3N0YXJ0VGltZVByZWNpc2lvbk'
    'IKCghfZW5kVGltZUITChFfZW5kVGltZVByZWNpc2lvbkINCgtfaW1wb3J0YW5jZUILCglfbG9j'
    'YXRpb25CDgoMX3BhcnRpY2lwYW50QgcKBV9ub3RlQgkKB19zb3VyY2VCCgoIX2NvbnRlbnRCCQ'
    'oHX3N0YXR1cw==');

