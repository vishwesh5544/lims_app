
import 'package:lims_app/models/test.dart';

abstract class PatientEvent {}

class OnSearch extends PatientEvent {
  final String value;
  OnSearch({this.value = ''});
}

class OnAddPatient extends PatientEvent {
  final bool value;
  int currentSelectedPriview;
  OnAddPatient({this.value = false, this.currentSelectedPriview = 0});
}

class IsPatient extends PatientEvent {
  final bool value;
  IsPatient({this.value = false});
}

class FetchAllPatients extends PatientEvent {}

class GenerateUmrNumber extends PatientEvent {}

class UmrNumberUpdated extends PatientEvent {
  final String umrNumber;

  UmrNumberUpdated(this.umrNumber);
}

class FirstNameUpdated extends PatientEvent {
  final String firstName;

  FirstNameUpdated(this.firstName);
}

class MiddleNameUpdated extends PatientEvent {
  final String middleName;

  MiddleNameUpdated(this.middleName);
}

class LastNameUpdated extends PatientEvent {
  final String lastName;

  LastNameUpdated(this.lastName);
}

class DobUpdated extends PatientEvent {
  final String dob;

  DobUpdated(this.dob);
}

class AgeUpdated extends PatientEvent {
  final String age;

  AgeUpdated(this.age);
}

class GenderUpdated extends PatientEvent {
  final String gender;

  GenderUpdated(this.gender);
}

class MobileNumberUpdated extends PatientEvent {
  final int mobileNumber;

  MobileNumberUpdated(this.mobileNumber);
}

class EmailUpdated extends PatientEvent {
  final String email;

  EmailUpdated(this.email);
}

class InsuranceProviderUpdated extends PatientEvent {
  final String insuranceProvider;

  InsuranceProviderUpdated(this.insuranceProvider);
}

class InsuranceNumberUpdated extends PatientEvent {
  final String insuranceNumber;

  InsuranceNumberUpdated(this.insuranceNumber);
}

class ConsultedDoctorUpdated extends PatientEvent {
  final String consultedDoctor;

  ConsultedDoctorUpdated(this.consultedDoctor);
}

class AddPatientFormSubmitted extends PatientEvent {}

class GenerateInvoiceNumber extends PatientEvent {}

class GenerateInvoice extends PatientEvent {}

class SelectedTestsUpdated extends PatientEvent {
  final List<Test> selectedTests;

  SelectedTestsUpdated(this.selectedTests);
}
