// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      id: json['id'] as int?,
      umrNumber: json['UMRNumber'] as String,
      firstName: json['firstname'] as String,
      middleName: json['middlename'] as String,
      lastName: json['lastname'] as String,
      dob: json['DOB'] as String,
      gender: json['gender'] as String,
      mobileNumber: json['mobilenumber'] as int,
      emailId: json['emailID'] as String,
      insuraceProvider: json['insuranceProvider'] as String,
      insuraceNumber: json['insuranceNumber'] as String,
      consultedDoctor: json['consultantDoctor'] as String,
      age: json['age'] as String,
    );

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'id': instance.id,
      'UMRNumber': instance.umrNumber,
      'firstname': instance.firstName,
      'middlename': instance.middleName,
      'lastname': instance.lastName,
      'DOB': instance.dob,
      'age': instance.age,
      'gender': instance.gender,
      'mobilenumber': instance.mobileNumber,
      'emailID': instance.emailId,
      'insuranceProvider': instance.insuraceProvider,
      'insuranceNumber': instance.insuraceNumber,
      'consultantDoctor': instance.consultedDoctor,
    };
