import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/utils/form_submission_status.dart';

class PatientState {
  final String umrNumber;
  final String firstName;
  final String middleName;
  final String lastName;
  final String dob;
  final String age;
  final String gender;
  final int mobileNumber;
  final String emailId;
  final String insuranceProvider;
  final String insuranceNumber;
  final String consultedDoctor;
  final String invoiceNumber;
  final FormSubmissionStatus formStatus;
  final List<Patient> patientsList;
  final List<Patient> searchPatientsList;
  final List<Test> selectedTests;
  final Patient? createdPatient;

  bool isAddPatient = false;
  bool isPatient = true;

  PatientState(
      {this.invoiceNumber = "",
      this.selectedTests = const [],
        this.isAddPatient = false,
        this.isPatient = true,
      this.createdPatient,
      this.umrNumber = "",
      this.firstName = "",
      this.middleName = "",
      this.lastName = "",
      this.dob = "",
      this.age = "",
      this.gender = "",
      this.mobileNumber = 0,
      this.emailId = "",
      this.insuranceProvider = "",
      this.insuranceNumber = "",
      this.consultedDoctor = "",
      this.patientsList = const [],
      this.searchPatientsList = const [],
      this.formStatus = const InitialFormStatus()});

  PatientState copyWith(
      {Patient? createdPatient,
      String? umrNumber,
      String? firstName,
      String? middleName,
      String? lastName,
      String? dob,
      String? age,
      String? gender,
      int? mobileNumber,
      String? emailId,
      String? insuranceProvider,
      String? insuranceNumber,
      String? consultedDoctor,
      String? invoiceNumber,
      List<Patient>? patientsList,
      List<Patient>? searchPatientsList,
      List<Test>? selectedTests,
        bool? isAddPatient,
        bool? isPatient,
      FormSubmissionStatus? formStatus}) {
    return PatientState(
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        selectedTests: selectedTests ?? this.selectedTests,
        createdPatient: createdPatient ?? this.createdPatient,
        umrNumber: umrNumber ?? this.umrNumber,
        consultedDoctor: consultedDoctor ?? this.consultedDoctor,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        middleName: middleName ?? this.middleName,
        isAddPatient: isAddPatient?? this.isAddPatient,
        isPatient: isPatient?? this.isPatient,
        dob: dob ?? this.dob,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        emailId: emailId ?? this.emailId,
        insuranceProvider: insuranceProvider ?? this.insuranceProvider,
        insuranceNumber: insuranceNumber ?? this.insuranceNumber,
        patientsList: patientsList ?? this.patientsList,
        searchPatientsList: searchPatientsList ?? this.searchPatientsList,
        formStatus: formStatus ?? this.formStatus);
  }
}
