// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
      id: json['id'] as int?,
      firstName: json['first_name'] as String?,
      umrNumber: json['umr_number'] as String?,
      testCode: json['test_code'] as String?,
      testname: json['testname'] as String?,
      processingUnit: json['processing_unit'] as String?,
      collectionUnit: json['collection_unit'] as String?,
      status: json['status'] as int?,
      invoiceNo: json['invoice_no'] as String?,
    );

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'umr_number': instance.umrNumber,
      'test_code': instance.testCode,
      'testname': instance.testname,
      'processing_unit': instance.processingUnit,
      'collection_unit': instance.collectionUnit,
      'status': instance.status,
      'invoice_no': instance.invoiceNo,
    };
