import 'package:lims_app/utils/form_submission_status.dart';

class InTransitState {
  final int? userId;
  final int? invoiceId;
  final int? patientId;
  final int? testId;
  final String? invoiceNo;
  final String? processingUnit;
  final String? collectionUnit;
  final int? status;
  final FormSubmissionStatus formStatus;

  InTransitState(
      {this.userId,
      this.invoiceId,
      this.patientId,
      this.testId,
      this.invoiceNo,
      this.processingUnit,
      this.collectionUnit,
      this.status,
      this.formStatus = const InitialFormStatus()});

  InTransitState copyWith({
    int? userId,
    int? invoiceId,
    int? patientId,
    int? testId,
    String? invoiceNo,
    String? processingUnit,
    String? collectionUnit,
    int? status,
    FormSubmissionStatus? formStatus,
  }) {
    return InTransitState(
        userId: userId ?? this.userId,
        patientId: patientId ?? this.patientId,
        invoiceNo: invoiceNo ?? this.invoiceNo,
        testId: testId ?? this.testId,
        processingUnit: processingUnit ?? this.processingUnit,
        collectionUnit: collectionUnit ?? this.collectionUnit,
        status: status ?? this.status,
        formStatus: formStatus ?? this.formStatus);
  }
}
