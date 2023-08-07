// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lab _$LabFromJson(Map<String, dynamic> json) => Lab(
      id: json['id'] as int?,
      labName: json['lab_name'] as String,
      emailId: json['email_id'] as String,
      contactNumber: json['contact_number'] as String,
      addressOne: json['address_1'] as String,
      addressTwo: json['address_2'] as String,
      country: json['country'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      unitType: json['unit_type'] as String,
      testDetails: (json['tests_details'] as List<dynamic>)
          .map((e) => LabTestDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LabToJson(Lab instance) => <String, dynamic>{
      'id': instance.id,
      'lab_name': instance.labName,
      'email_id': instance.emailId,
      'contact_number': instance.contactNumber,
      'address_1': instance.addressOne,
      'address_2': instance.addressTwo,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'unit_type': instance.unitType,
      'tests_details': instance.testDetails?.map((e) => e.toJson()).toList(),
    };
