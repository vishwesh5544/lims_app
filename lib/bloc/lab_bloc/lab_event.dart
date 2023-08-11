import 'package:lims_app/models/lab_test_detail.dart';

abstract class LabEvent {}

class FetchAllLabs extends LabEvent {}

class OnAddCenter extends LabEvent {
  final bool value;
  int currentSelectedPriview = -1;
  OnAddCenter({this.value = false, this.currentSelectedPriview = -1});
}

class AddCentreFormSubmitted extends LabEvent {
  final String labName;
  final String emailId;
  final String contactNumber;
  final String addressOne;
  final String addressTwo;
  final String country;
  final String state;
  final String city;
  final String unitType;
  final List<LabTestDetail> testDetails;

  AddCentreFormSubmitted(
      {required this.labName,
      required this.emailId,
      required this.contactNumber,
      required this.addressOne,
      required this.addressTwo,
      required this.country,
      required this.state,
      required this.city,
      required this.unitType,
      required this.testDetails});
}
