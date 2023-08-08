import 'package:json_annotation/json_annotation.dart';
import 'package:lims_app/models/lab_test_detail.dart';


part 'lab.g.dart';

@JsonSerializable(explicitToJson: true)
class Lab {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "lab_name")
  final String labName;
  @JsonKey(name: "email_id")
  final String emailId;
  @JsonKey(name: "contact_number")
  final String contactNumber;
  @JsonKey(name: "address_1")
  final String addressOne;
  @JsonKey(name: "address_2")
  final String addressTwo;
  @JsonKey(name: "country")
  final String country;
  @JsonKey(name: "state")
  final String state;
  @JsonKey(name: "city")
  final String city;
  @JsonKey(name: "unit_type")
  final String unitType;
  @JsonKey(name: "tests_details")
  final List<LabTestDetail>? testDetails;


  Lab(
      {this.id,
      required this.labName,
      required this.emailId,
      required this.contactNumber,
      required this.addressOne,
      required this.addressTwo,
      required this.country,
      required this.state,
      required this.city,
      required this.unitType,
      required this.testDetails});

  factory Lab.fromJson(Map<String, dynamic> json) => _$LabFromJson(json);

  Map<String, dynamic> toJson() => _$LabToJson(this);
}
