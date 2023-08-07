import 'package:json_annotation/json_annotation.dart';

part "patient.g.dart";

@JsonSerializable(explicitToJson: true)
class Patient {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "UMRNumber")
  final String umrNumber;
  @JsonKey(name: "firstname")
  final String firstName;
  @JsonKey(name: "middlename")
  final String middleName;
  @JsonKey(name: "lastname")
  final String lastName;
  @JsonKey(name: "DOB")
  final String dob;
  @JsonKey(name: "age")
  final String age;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "mobilenumber")
  final int mobileNumber;
  @JsonKey(name: "emailID")
  final String emailId;
  @JsonKey(name: "insuranceProvider")
  final String insuraceProvider;
  @JsonKey(name: "insuranceNumber")
  final String insuraceNumber;
  @JsonKey(name: "consultantDoctor")
  final String consultedDoctor;

  Patient(
      {this.id, required this.umrNumber,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.dob,
      required this.gender,
      required this.mobileNumber,
      required this.emailId,
      required this.insuraceProvider,
      required this.insuraceNumber,
      required this.consultedDoctor,
      required this.age});


  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);

  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
