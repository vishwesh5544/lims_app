// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Test _$TestFromJson(Map<String, dynamic> json) => Test(
      typeOfTemperature: json['typeof_temperature'] as String,
      testCode: json['test_code'] as String,
      testName: json['testname'] as String,
      department: json['department'] as String,
      temperature: json['temperature'] as String,
      sampleType: json['sample_type'] as String,
      vacutainer: json['vacutainer'] as String,
      volume: json['volume'] as String,
      typeOfVolume: json['typeof_volume'] as String,
      method: json['method'] as String,
      turnAroundTime: json['tat'] as String,
      price: json['price'] as int,
      taxPercentage: json['tax'] as int,
      totalPrice: json['total_price'] as int,
      indications: json['indications'] as String,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$TestToJson(Test instance) => <String, dynamic>{
      'id': instance.id,
      'test_code': instance.testCode,
      'testname': instance.testName,
      'department': instance.department,
      'temperature': instance.temperature,
      'typeof_temperature': instance.typeOfTemperature,
      'sample_type': instance.sampleType,
      'vacutainer': instance.vacutainer,
      'volume': instance.volume,
      'typeof_volume': instance.typeOfVolume,
      'method': instance.method,
      'tat': instance.turnAroundTime,
      'price': instance.price,
      'tax': instance.taxPercentage,
      'total_price': instance.totalPrice,
      'indications': instance.indications,
    };
