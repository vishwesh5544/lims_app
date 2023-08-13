import "package:equatable/equatable.dart";
import "package:json_annotation/json_annotation.dart";

part "test.g.dart";

@JsonSerializable(explicitToJson: true)
class Test extends Equatable {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "test_code")
  final String testCode;
  @JsonKey(name: "testname")
  final String testName;
  @JsonKey(name: "department")
  final String department;
  @JsonKey(name: "temperature")
  final String temperature;
  @JsonKey(name: "typeof_temperature")
  final String typeOfTemperature;
  @JsonKey(name: "sample_type")
  final String sampleType;
  @JsonKey(name: "vacutainer")
  final String vacutainer;
  @JsonKey(name: "volume")
  final String volume;
  @JsonKey(name: "typeof_volume")
  final String typeOfVolume;
  @JsonKey(name: "method")
  final String method;
  @JsonKey(name: "tat")
  final String turnAroundTime;
  @JsonKey(name: "price")
  final int price;
  @JsonKey(name: "tax")
  final int taxPercentage;
  @JsonKey(name: "total_price")
  final int totalPrice; // price + (price * tax)
  @JsonKey(name: "indications")
  final String indications;

  Test(
      {required this.typeOfTemperature,
      required this.testCode,
      required this.testName,
      required this.department,
      required this.temperature,
      required this.sampleType,
      required this.vacutainer,
      required this.volume,
      required this.typeOfVolume,
      required this.method,
      required this.turnAroundTime,
      required this.price,
      required this.taxPercentage,
      required this.totalPrice,
      required this.indications,
      this.id});

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);

  Map<String, dynamic> toJson() => _$TestToJson(this);

  @override
  List<Object?> get props => [id];
}
