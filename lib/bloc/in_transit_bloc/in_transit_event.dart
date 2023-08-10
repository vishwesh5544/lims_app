abstract class InTransitEvent {}

class FetchAllInvoiceMapping extends InTransitEvent {}

class ViewQrCode extends InTransitEvent {
  final int value;

  ViewQrCode(this.value);
}


class SearchPatient extends InTransitEvent {
  final String searchString;

  SearchPatient(this.searchString);
}

class ResetState extends InTransitEvent {

}


class FetchSearchResults extends InTransitEvent {
  final String searchInput;

  FetchSearchResults(this.searchInput);
}

class FetchFilteredLabs extends InTransitEvent {}

class UpdateInTransit extends InTransitEvent {
  final int userId;
  final int? invoiceId;
  final int? patientId;
  final int? testId;
  final String? invoiceNo;
  final String? processingUnit;
  final String? collectionUnit;
  final int? status;

  UpdateInTransit(
      {required this.userId,
      this.invoiceId,
      this.patientId,
      this.testId,
      this.invoiceNo,
      this.processingUnit,
      this.collectionUnit,
      this.status});
}
