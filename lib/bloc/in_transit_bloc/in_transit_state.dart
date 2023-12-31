import 'package:lims_app/models/invoice_mapping.dart';
import 'package:lims_app/models/lab.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/search_result.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/utils/form_submission_status.dart';
import 'package:lims_app/utils/update_status.dart';

class InTransitState {
  final Patient? patient;
  final List<Test>? testsList;
  final List<InvoiceMapping>? invoiceMappings;
  final List<Lab>? filteredLabs;
  final List<SearchResult>? searchResults;
  final FormSubmissionStatus formStatus;
  final UpdateStatus updateStatus;
  int currentVisibleQrCode = -1;

  InTransitState(
      {this.filteredLabs = const [],
      this.testsList = const [],
      this.invoiceMappings = const [],
      this.searchResults = const [],
      this.patient,
      this.currentVisibleQrCode = -1,
      this.formStatus = const InitialFormStatus(),
      this.updateStatus = const InitialUpdateStatus()});

  InTransitState copyWith(
      {List<Test>? testsList,
      List<Lab>? filteredLabs,
      List<SearchResult>? searchResults,
      List<InvoiceMapping>? invoiceMappings,
      Patient? patient,
      FormSubmissionStatus? formStatus,
      int? currentVisibleQrCode = -1,
      UpdateStatus? updateStatus}) {
    return InTransitState(
      searchResults: searchResults ?? this.searchResults,
      filteredLabs: filteredLabs ?? this.filteredLabs,
      invoiceMappings: invoiceMappings ?? this.invoiceMappings,
      testsList: testsList ?? this.testsList,
      patient: patient ?? this.patient,
      formStatus: formStatus ?? this.formStatus,
      currentVisibleQrCode: currentVisibleQrCode ?? this.currentVisibleQrCode,
      updateStatus: updateStatus ?? this.updateStatus,
    );
  }

  InTransitState copyWithNullPatient() {
    return InTransitState(
      searchResults: searchResults,
      filteredLabs: filteredLabs,
      invoiceMappings: invoiceMappings,
      testsList: testsList,
      patient: null,
      formStatus: formStatus,
      currentVisibleQrCode: currentVisibleQrCode,
      updateStatus: updateStatus,
    );
  }
}
