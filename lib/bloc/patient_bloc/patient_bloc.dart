import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lims_app/bloc/patient_bloc/patient_event.dart';
import 'package:lims_app/bloc/patient_bloc/patient_state.dart';
import 'package:lims_app/models/invoice_mapping.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/response_callback.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/repositories/patient_repository.dart';
import 'package:lims_app/utils/form_submission_status.dart';
import 'package:lims_app/utils/lims_logger.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository patientRepository;

  PatientBloc({required this.patientRepository}) : super(PatientState());

  @override
  Stream<PatientState> mapEventToState(PatientEvent event) async* {
    if (event is FetchAllPatients) {
      final response = await patientRepository.getAllPatients();
      yield state.copyWith(
          patientsList: response.data, searchPatientsList: response.data);
    } else if (event is GenerateUmrNumber) {
      var random = Random();
      var next = random.nextDouble() * 1000000;
      while (next < 100000) {
        next *= 10;
      }
      var gen = next.toString().split('.');
      String generatedUmrNumber = "UMR${gen[0]}";
      yield state.copyWith(umrNumber: generatedUmrNumber);
    } else if (event is UmrNumberUpdated) {
      yield state.copyWith(umrNumber: event.umrNumber);
    } else if (event is FirstNameUpdated) {
      yield state.copyWith(firstName: event.firstName);
    } else if (event is MiddleNameUpdated) {
      yield state.copyWith(middleName: event.middleName);
    } else if (event is LastNameUpdated) {
      yield state.copyWith(lastName: event.lastName);
    } else if (event is DobUpdated) {
      yield state.copyWith(dob: event.dob);
    } else if (event is AgeUpdated) {
      yield state.copyWith(age: event.age);
    } else if (event is GenderUpdated) {
      yield state.copyWith(gender: event.gender);
    } else if (event is MobileNumberUpdated) {
      yield state.copyWith(mobileNumber: event.mobileNumber);
    } else if (event is EmailUpdated) {
      yield state.copyWith(emailId: event.email);
    } else if (event is InsuranceProviderUpdated) {
      yield state.copyWith(insuranceProvider: event.insuranceProvider);
    } else if (event is InsuranceNumberUpdated) {
      yield state.copyWith(insuranceNumber: event.insuranceNumber);
    } else if (event is ConsultedDoctorUpdated) {
      yield state.copyWith(consultedDoctor: event.consultedDoctor);
    } else if (event is AddPatientFormSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        Patient newPatient = Patient(
            umrNumber: state.umrNumber,
            insuraceProvider: state.insuranceProvider,
            emailId: state.emailId,
            mobileNumber: state.mobileNumber,
            dob: state.dob,
            insuraceNumber: state.insuranceNumber,
            firstName: state.firstName,
            middleName: state.middleName,
            lastName: state.lastName,
            gender: state.gender,
            consultedDoctor: state.consultedDoctor,
            age: state.age);
        ResponseCallback<Patient> response;
        if (event.isUpdate) {
          response =
              await patientRepository.updatePatient(newPatient, event.userId!);
        } else {
          response = await patientRepository.addPatient(newPatient);
        }
        yield state.copyWith(
            createdPatient: response.data, formStatus: SubmissionSuccess());
        LimsLogger.log(
            "*** Patient successfully created => ${response.data?.toJson()}");
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    } else if (event is SelectedTestsUpdated) {
      yield state.copyWith(selectedTests: event.selectedTests);
    } else if (event is GenerateInvoiceNumber) {
      /// event to generate invoice number and save in state
      // generate random number
      var random = Random();
      var next = random.nextDouble() * 1000000;
      while (next < 100000) {
        next *= 10;
      }

      String generatedInvoiceNumber = "IN${next.ceil()}";
      yield state.copyWith(invoiceNumber: generatedInvoiceNumber);
    } else if (event is GenerateInvoice) {
      /// add invoice details
      List<InvoiceMapping> invoices = [];

      for (Test test in state.selectedTests) {
        if (state.createdPatient?.id != null && test.id != null) {
          InvoiceMapping invoice = InvoiceMapping(
            state.createdPatient!.id!,
            test.id!,
            state.invoiceNumber,
            status: 1,
          );
          invoices.add(invoice);
        }
      }

      final response = await patientRepository.addInvoice(invoices);
      yield state.copyWith(createdPatientInvoices: response.data);
    } else if (event is OnSearch) {
      List<Patient> data = [];

      for (Patient patient in state.patientsList) {
        if ("${patient.lastName} ${patient.middleName} ${patient.firstName}"
            .toLowerCase()
            .contains(event.value.trim())) {
          data.add(patient);
        }
      }

      yield state.copyWith(searchPatientsList: data);
    } else if (event is OnAddPatient) {
      yield state.copyWith(
          isAddPatient: event.value,
          currentSelectedPriview: event.currentSelectedPriview);
    } else if (event is IsPatient) {
      yield state.copyWith(isPatient: event.value);
    }
  }
}
