import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "first_name")
  String? firstName;
  @JsonKey(name: "umr_number")
  String? umrNumber;
  @JsonKey(name: "test_code")
  String? testCode;
  @JsonKey(name: "testname")
  String? testname;
  @JsonKey(name: "processing_unit")
  String? processingUnit;
  @JsonKey(name: "collection_unit")
  String? collectionUnit;
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "invoice_no")
  String? invoiceNo;

  SearchResult({
    this.id,
    this.firstName,
    this.umrNumber,
    this.testCode,
    this.testname,
    this.processingUnit,
    this.collectionUnit,
    this.status,
    this.invoiceNo,
  });

  SearchResult copyWith({
    int? id,
    String? firstName,
    String? umrNumber,
    String? testCode,
    String? testname,
    String? processingUnit,
    String? collectionUnit,
    int? status,
    String? invoiceNo,
  }) =>
      SearchResult(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        umrNumber: umrNumber ?? this.umrNumber,
        testCode: testCode ?? this.testCode,
        testname: testname ?? this.testname,
        processingUnit: processingUnit ?? this.processingUnit,
        collectionUnit: collectionUnit ?? this.collectionUnit,
        status: status ?? this.status,
        invoiceNo: invoiceNo ?? this.invoiceNo,
      );

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}
