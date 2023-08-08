import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lims_app/bloc/in_transit_bloc/in_transit_event.dart';
import 'package:lims_app/bloc/in_transit_bloc/in_transit_state.dart';
import 'package:lims_app/models/in_transit.dart';
import 'package:lims_app/repositories/in_transit_repository.dart';
import 'package:lims_app/utils/form_submission_status.dart';

class InTransitBloc extends Bloc<InTransitEvent, InTransitState> {
  InTransitRepository inTransitRepository;

  InTransitBloc({required this.inTransitRepository}) : super(InTransitState());

  @override
  Stream<InTransitState> mapEventToState(InTransitEvent event) async* {
    if (event is FetchAllInvoiceMapping) {
      // TODO: Fetch all invoice mapping from repository, set state
    } else if (event is SearchPatient) {
      final patientAndTestsResponse = await inTransitRepository.getPatientByEmail(event.searchString);
      yield state.copyWith(
          testsList: patientAndTestsResponse.data?.tests, patient: patientAndTestsResponse.data?.patient);
      final invoiceMappingsResponse = await inTransitRepository.getInvoiceMappingsForUser(state.patient!.id!);
      yield state.copyWith(invoiceMappings: invoiceMappingsResponse.data);
    } else if (event is UpdateInTransit) {
      // TODO: Update invoice mapping using user ID from repository, set state

      yield state.copyWith(formStatus: FormSubmitting());

      try {
        InTransit inTransit = InTransit(
            patientId: state.patient!.id,
            invoiceNo: event.invoiceNo,
            id: event.invoiceId,
            testId: event.testId,
            processingUnit: event.processingUnit,
            collectionUnit: event.collectionUnit,
            status: event.status);

        final response = await inTransitRepository.updateInvoiceMapping(inTransit, event.invoiceId!);
        final data = response.data;
        print(data);
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
