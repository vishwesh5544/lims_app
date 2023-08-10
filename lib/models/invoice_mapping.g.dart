// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_mapping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceMapping _$InvoiceMappingFromJson(Map<String, dynamic> json) => InvoiceMapping(
      json['patient_id'] as int,
      json['test_id'] as int,
      json['invoice_no'] as String,
      processingUnit: json['processing_unit'] as String?,
      collectionUnit: json['collection_unit'] as String?,
      id: json['id'] as int?,
      ptid: json['patienttestid'] as int?,
      status: json['status'] as int? ?? 0,
    );

Map<String, dynamic> _$InvoiceMappingToJson(InvoiceMapping instance) => <String, dynamic>{
      'id': instance.id,
      'patient_id': instance.patientId,
      'test_id': instance.testId,
      'invoice_no': instance.invoiceNumber,
      'processing_unit': instance.processingUnit,
      'collection_unit': instance.collectionUnit,
      'status': instance.status,
      'patienttestid': instance.ptid,
    };
