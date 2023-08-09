abstract class TestEvent {}

class FetchAllTests extends TestEvent {}

class TestCodeUpdated extends TestEvent {
  final String testCode;

  TestCodeUpdated(this.testCode);
}

class OnSearch extends TestEvent {
  final String value;
  OnSearch({this.value = ''});
}

class OnAddTest extends TestEvent {
  final bool value;
  int currentSelectedPriview;
  OnAddTest({this.value = false, this.currentSelectedPriview = 0});
}

class TestNameUpdated extends TestEvent {
  final String testName;

  TestNameUpdated(this.testName);
}

class DepartmentUpdated extends TestEvent {
  final String department;

  DepartmentUpdated(this.department);
}

class TemperatureUpdated extends TestEvent {
  final String temperature;

  TemperatureUpdated(this.temperature);
}

class TypeOfTemperatureUpdated extends TestEvent {
  final String typeOfTemperature;

  TypeOfTemperatureUpdated(this.typeOfTemperature);
}

class SampleTypeUpdated extends TestEvent {
  final String sampleType;

  SampleTypeUpdated(this.sampleType);
}

class VacutainerUpdated extends TestEvent {
  final String vacutainer;

  VacutainerUpdated(this.vacutainer);
}

class VolumeUpdated extends TestEvent {
  final String volume;

  VolumeUpdated(this.volume);
}

class TypeOfVolumeUpdated extends TestEvent {
  final String typeOfVolume;

  TypeOfVolumeUpdated(this.typeOfVolume);
}

class MethodUpdated extends TestEvent {
  final String method;

  MethodUpdated(this.method);
}

class TurnAroundTimeUpdated extends TestEvent {
  final String turnAroundTime;

  TurnAroundTimeUpdated(this.turnAroundTime);
}

class PriceUpdated extends TestEvent {
  final int price;

  PriceUpdated(this.price);
}

class TaxPercentageUpdated extends TestEvent {
  final int taxPercentage;

  TaxPercentageUpdated(this.taxPercentage);
}

class TotalPriceUpdated extends TestEvent {
  final int totalPrice;

  TotalPriceUpdated(this.totalPrice);
}

class IndicationsUpdated extends TestEvent {
  final String indications;

  IndicationsUpdated(this.indications);
}

class TestSearchUpdated extends TestEvent {
  final String searchField;

  TestSearchUpdated(this.searchField);
}

class AddTestFormSubmitted extends TestEvent {
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
  final int taxPercentage;
  final int totalPrice;
  final String indications;

  AddTestFormSubmitted(
      {required this.testCode,
      required this.testName,
      required this.department,
      required this.temperature,
      required this.typeOfTemperature,
      required this.sampleType,
      required this.vacutainer,
      required this.volume,
      required this.typeOfVolume,
      required this.method,
      required this.turnAroundTime,
      required this.price,
      required this.taxPercentage,
      required this.totalPrice,
      required this.indications});
}
