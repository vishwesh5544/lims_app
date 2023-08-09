import 'package:lims_app/models/invoice_mapping.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/utils/form_submission_status.dart';
import 'package:lims_app/utils/update_status.dart';

class InTransitState {
  final Patient? patient;
  final List<Test>? testsList;
  final List<InvoiceMapping>? invoiceMappings;
  final FormSubmissionStatus formStatus;
  final UpdateStatus updateStatus;

  InTransitState(
      {this.testsList = const [],
      this.invoiceMappings = const [],
      this.patient,
      this.formStatus = const InitialFormStatus(),
      this.updateStatus = const InitialUpdateStatus()});

  InTransitState copyWith(
      {List<Test>? testsList,
      List<InvoiceMapping>? invoiceMappings,
      Patient? patient,
      FormSubmissionStatus? formStatus,
      UpdateStatus? updateStatus}) {
    return InTransitState(
      invoiceMappings: invoiceMappings ?? this.invoiceMappings,
      testsList: testsList ?? this.testsList,
      patient: patient ?? this.patient,
      formStatus: formStatus ?? this.formStatus,
      updateStatus: updateStatus ?? this.updateStatus,
    );
  }
}
