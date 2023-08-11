import 'package:lims_app/models/test.dart';
import 'package:lims_app/utils/form_submission_status.dart';

class TestState {
  final String testCode;
  final String testName;
  final String department;
  final String temperature;
  final String typeOfTemperature;
  final String sampleType;
  final String vacutainer;
  final String volume;
  final String typeOfVolume;
  final String method;
  final String turnAroundTime;
  final int price;
  final bool isAddTest;
  int currentSelectedPriview = -1;
  final int taxPercentage;
  final int totalPrice; // price + (price * tax)
  final String indications;
  final String searchField;
  final List<Test> testsList;
  final List<Test> searchTestsList;
  final FormSubmissionStatus formStatus;

  TestState(
      {this.testCode = "",
      this.testName = "",
      this.department = "",
      this.temperature = "",
      this.typeOfTemperature = "",
      this.sampleType = "",
      this.vacutainer = "",
      this.volume = "",
      this.typeOfVolume = "",
      this.method = "",
      this.turnAroundTime = "",
      this.price = 0,
        this.isAddTest = false,
        this.currentSelectedPriview = -1,
      this.taxPercentage = 0,
      this.totalPrice = 0,
      this.indications = "",
      this.searchField = "",
      this.testsList = const [],
        this.searchTestsList = const [],
      this.formStatus = const InitialFormStatus()});

  TestState copyWith(
      {String? testCode,
      String? testName,
      String? department,
      String? temperature,
      String? typeOfTemperature,
      String? sampleType,
      String? vacutainer,
      String? volume,
      String? typeOfVolume,
      String? method,
      String? turnAroundTime,
      int? price,
      int? taxPercentage,
      int? totalPrice,
      String? indications,
      String? searchField,
      List<Test>? testsList,
        List<Test>? searchTestsList,
        bool? isAddTest,
        int? currentSelectedPriview = -1,
      FormSubmissionStatus? formStatus}) {
    return TestState(
        testCode: testCode ?? this.testCode,
        testName: testName ?? this.testName,
        department: department ?? this.department,
        temperature: temperature ?? this.temperature,
        typeOfTemperature: typeOfTemperature ?? this.typeOfTemperature,
        sampleType: sampleType ?? this.sampleType,
        vacutainer: vacutainer ?? this.vacutainer,
        volume: volume ?? this.volume,
        typeOfVolume: typeOfVolume ?? this.typeOfVolume,
        method: method ?? this.method,
        turnAroundTime: turnAroundTime ?? this.turnAroundTime,
        price: price ?? this.price,
        isAddTest: isAddTest?? this.isAddTest,
        currentSelectedPriview: currentSelectedPriview?? this.currentSelectedPriview,
        taxPercentage: taxPercentage ?? this.taxPercentage,
        totalPrice: totalPrice ?? this.totalPrice,
        indications: indications ?? this.indications,
        searchField: searchField ?? this.searchField,
        testsList: testsList ?? this.testsList,
        searchTestsList: searchTestsList ?? this.searchTestsList,
        formStatus: formStatus ?? this.formStatus);
  }
}
