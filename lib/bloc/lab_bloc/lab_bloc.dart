import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lims_app/bloc/lab_bloc/lab_event.dart';
import 'package:lims_app/bloc/lab_bloc/lab_state.dart';
import 'package:lims_app/models/lab.dart';
import 'package:lims_app/models/lab_test_detail.dart';
import 'package:lims_app/repositories/lab_repository.dart';
import 'package:lims_app/utils/form_submission_status.dart';

class LabBloc extends Bloc<LabEvent, LabState> {
  final LabRepository labRepository;

  LabBloc({required this.labRepository}) : super(LabState());

  @override
  Stream<LabState> mapEventToState(LabEvent event) async* {
    if (event is FetchAllLabs) {
      final res = await labRepository.getAllLabs();
      yield state.copyWith(labsList: res.data);
    } else if (event is AddCentreFormSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        Lab newLab = Lab(
            unitType: event.unitType,
            testDetails: event.testDetails,
            state: event.state,
            country: event.country,
            city: event.city,
            addressOne: event.addressOne,
            addressTwo: event.addressTwo,
            labName: event.labName,
            emailId: event.emailId,
            contactNumber: event.contactNumber);

        final response = await labRepository.addLab(newLab);
        final createdLab = response.data;
        yield state.copyWith(
            id: createdLab?.id,
            labName: createdLab?.labName,
            emailId: createdLab?.emailId,
            contactNumber: createdLab?.contactNumber,
            addressOne: createdLab?.addressOne,
            addressTwo: createdLab?.addressTwo,
            country: createdLab?.country,
            state: createdLab?.state,
            city: createdLab?.city,
            unitType: createdLab?.unitType,
            testDetails: createdLab?.testDetails,
            formStatus: SubmissionSuccess());
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
