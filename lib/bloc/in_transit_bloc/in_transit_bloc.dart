import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lims_app/bloc/in_transit_bloc/in_transit_event.dart';
import 'package:lims_app/bloc/in_transit_bloc/in_transit_state.dart';
import 'package:lims_app/models/in_transit.dart';
import 'package:lims_app/models/invoice_mapping.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/patient_and_test.dart';
import 'package:lims_app/models/response_callback.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/repositories/in_transit_repository.dart';
import 'package:lims_app/repositories/patient_repository.dart';
import 'package:lims_app/utils/form_submission_status.dart';
import 'package:lims_app/utils/update_status.dart';

class InTransitBloc extends Bloc<InTransitEvent, InTransitState> {
  InTransitRepository inTransitRepository;
  // TODO : Shouldn't be here, refactor it properly
  PatientRepository patientRepository;

  InTransitBloc({
    required this.inTransitRepository,
    required this.patientRepository,
  }) : super(InTransitState());

  List<Test> cachedTests = <Test>[];
  List<InvoiceMapping> cachedInvoiceMapping = <InvoiceMapping>[];

  Future<({List<Test> test, List<InvoiceMapping> invoiceMappings})>
      getInvoiceMappingForPatient(Patient patient) async {
    final result = await Future.wait([
      inTransitRepository.getPatientByEmail(patient.emailId),
      inTransitRepository.getInvoiceMappingsForUser(patient.id!)
    ]);
    final tests = <Test>[];
    final invoiceMappings = <InvoiceMapping>[];

    final patientAndTestsResponse =
        result.first as ResponseCallback<PatientAndTests>;
    final invoiceMappingsResponse =
        result.last as ResponseCallback<List<InvoiceMapping>>;
    if (patientAndTestsResponse.data != null &&
        patientAndTestsResponse.data!.tests.isNotEmpty) {
      tests.addAll(patientAndTestsResponse.data!.tests);
    }
    if (invoiceMappingsResponse.data != null &&
        invoiceMappingsResponse.data!.isNotEmpty) {
      invoiceMappings.addAll(invoiceMappingsResponse.data!);
    }
    return (test: tests, invoiceMappings: invoiceMappings);
  }

  @override
  Stream<InTransitState> mapEventToState(InTransitEvent event) async* {
    if (event is FetchAllInvoiceMapping) {
      // TODO: Fetch all invoice mapping from repository, set state
    } else if (event is FetchFilteredLabs) {
      final response = await inTransitRepository.getAllFilteredLabs();
      yield state.copyWith(filteredLabs: response.data);
    } else if (event is SearchPatient) {
      if (event.searchString.trim().isEmpty) {
        yield state.copyWith(
          testsList: cachedTests,
          invoiceMappings: cachedInvoiceMapping,
        );
        final patientsData = await patientRepository.getAllPatients();
        final patients = patientsData.data;
        if (patients == null || patients.isEmpty) {
          yield state.copyWith(testsList: [], patient: null);
        } else {
          final result = await Future.wait(
              patients.map((e) => getInvoiceMappingForPatient(e)));
          final tests = result.fold(<Test>[],
              (previousValue, element) => previousValue + element.test);
          final invoiceMappings = result.fold(
            <InvoiceMapping>[],
            (previousValue, element) => previousValue + element.invoiceMappings,
          );
          cachedTests = tests;
          cachedInvoiceMapping = invoiceMappings;
          yield state.copyWith(
            testsList: tests,
            invoiceMappings: invoiceMappings,
          );
        }
      } else {
        if (event.searchString.trim().isNotEmpty &&
            event.searchString.trim().length > 3) {
          final patientAndTestsResponse =
              await inTransitRepository.getPatientByEmail(event.searchString);
          yield state.copyWith(
            testsList: patientAndTestsResponse.data?.tests,
            patient: patientAndTestsResponse.data?.patient,
          );
        } else if (event.searchString.trim().isEmpty) {
          yield state.copyWith(testsList: [], patient: null);
        }

        final invoiceMappingsResponse = await inTransitRepository
            .getInvoiceMappingsForUser(state.patient!.id!);
        yield state.copyWith(invoiceMappings: invoiceMappingsResponse.data);
      }
    } else if (event is UpdateInTransit) {
      // TODO: Update invoice mapping using user ID from repository, set state

      yield state.copyWith(
          formStatus: FormSubmitting(), updateStatus: Updating());

      try {
        InTransit inTransit = InTransit(
            patientId: state.patient!.id,
            invoiceNo: event.invoiceNo,
            id: event.invoiceId,
            testId: event.testId,
            processingUnit: event.processingUnit,
            collectionUnit: event.collectionUnit,
            status: event.status);

        final response = await inTransitRepository.updateInvoiceMapping(
            inTransit, event.invoiceId!);
        final data = response.data;
        List<InvoiceMapping> oldMappings = state.invoiceMappings ?? [];
        if (data != null) {
          oldMappings.removeWhere((element) => element.id == data.id);
          oldMappings.add(data);
        }
        yield state.copyWith(
            invoiceMappings: oldMappings, updateStatus: Updated());
      } on Exception catch (e) {
        yield state.copyWith(
            formStatus: SubmissionFailed(e),
            updateStatus: UpdatingFailed(exception: e));
      }
    } else if (event is ViewQrCode) {
      yield state.copyWith(currentVisibleQrCode: event.value);
    } else if (event is ResetState) {
      yield state.copyWith(
          filteredLabs: [], invoiceMappings: [], testsList: [], patient: null);
    } else if (event is FetchSearchResults) {
      var input = event.searchInput;
      int? inputAsInt = int.tryParse(input);
      if (inputAsInt != null) {
        String inputString = input.toString();
        List<String> list = List<String>.generate(
            inputString.length, (index) => inputString[index]);
        List<InvoiceMapping> invoices = [];
        list.removeLast();
        var interimInput = int.parse(list.join(""));
        final responseForPtid =
            await inTransitRepository.getSearchResultsByPtid(interimInput);

        if (responseForPtid.data != null && responseForPtid.data!.isEmpty) {
          // for(var r in responseForPtid.data!) {
          //
          // }

          yield state.copyWith(searchResults: responseForPtid.data);
        } else {
          final responseForInvoiceId =
              await inTransitRepository.getSearchResultsByInvoiceId(inputAsInt);
          yield state.copyWith(searchResults: responseForInvoiceId.data);
        }
      } else {
        final responseForFirstName =
            await inTransitRepository.getSearchResultsByFirstName(input);
        yield state.copyWith(searchResults: responseForFirstName.data);
      }
    }
  }
}
