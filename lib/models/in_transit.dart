import 'package:json_annotation/json_annotation.dart';

part "in_transit.g.dart";

@JsonSerializable(explicitToJson: true)
class InTransit {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "patient_id")
  final int? patientId;
  @JsonKey(name: "test_id")
  final int? testId;
  @JsonKey(name: "invoice_no")
  final String? invoiceNo;
  @JsonKey(name: "processing_unit")
  final String? processingUnit;
  @JsonKey(name: "collection_unit")
  final String? collectionUnit;
  @JsonKey(name: "status")
  final int? status;

  InTransit(
      {this.id, this.patientId, this.testId, this.invoiceNo, this.processingUnit, this.collectionUnit, this.status});

  factory InTransit.fromJson(Map<String, dynamic> json) => _$InTransitFromJson(json);

  Map<String, dynamic> toJson() => _$InTransitToJson(this);
}
