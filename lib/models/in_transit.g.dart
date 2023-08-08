// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_transit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InTransit _$InTransitFromJson(Map<String, dynamic> json) => InTransit(
      id: json['id'] as int?,
      patientId: json['patient_id'] as int?,
      testId: json['test_id'] as int?,
      invoiceNo: json['invoice_no'] as String?,
      processingUnit: json['processing_unit'] as String?,
      collectionUnit: json['collection_unit'] as String?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$InTransitToJson(InTransit instance) => <String, dynamic>{
      'id': instance.id,
      'patient_id': instance.patientId,
      'test_id': instance.testId,
      'invoice_no': instance.invoiceNo,
      'processing_unit': instance.processingUnit,
      'collection_unit': instance.collectionUnit,
      'status': instance.status,
    };
