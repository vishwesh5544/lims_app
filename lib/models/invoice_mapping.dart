import 'package:json_annotation/json_annotation.dart';

part "invoice_mapping.g.dart";

@JsonSerializable(explicitToJson: true)
class InvoiceMapping {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "patient_id")
  final int patientId;
  @JsonKey(name: "test_id")
  final int testId;
  @JsonKey(name: "invoice_no")
  final String invoiceNumber;
  @JsonKey(name: "processing_unit")
  final String? processingUnit;
  @JsonKey(name: "collection_unit")
  final String? collectionUnit;
  @JsonKey(name: "status")
  final int status;
  @JsonKey(name : "patienttestid")
  final int? ptid;
  @JsonKey(name : "invoice_id")
  final int? invoiceId;


  InvoiceMapping(this.patientId, this.testId, this.invoiceNumber,
      {this.processingUnit, this.collectionUnit, this.id, this.ptid, this.invoiceId, this.status = 0});

  factory InvoiceMapping.fromJson(Map<String, dynamic> json) => _$InvoiceMappingFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceMappingToJson(this);
}
