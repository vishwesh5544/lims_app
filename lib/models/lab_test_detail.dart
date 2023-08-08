import 'package:json_annotation/json_annotation.dart';

part 'lab_test_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class LabTestDetail {
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "testcode")
  final String testCode;

  LabTestDetail(this.name, this.testCode);

  factory LabTestDetail.fromJson(Map<String, dynamic> json) => _$LabTestDetailFromJson(json);

  Map<String, dynamic> toJson() => _$LabTestDetailToJson(this);
}
