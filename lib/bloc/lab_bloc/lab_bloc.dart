import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lims_app/bloc/lab_bloc/lab_event.dart';
import 'package:lims_app/bloc/lab_bloc/lab_state.dart';
import 'package:lims_app/models/lab.dart';
import 'package:lims_app/models/response_callback.dart';
import 'package:lims_app/repositories/lab_repository.dart';
import 'package:lims_app/utils/form_submission_status.dart';
import 'package:lims_app/utils/lims_logger.dart';

class LabBloc extends Bloc<LabEvent, LabState> {
  final LabRepository _labRepository;

  LabBloc({required LabRepository labRepository}) : _labRepository = labRepository, super(LabState());

  @override
  Stream<LabState> mapEventToState(LabEvent event) async* {
    if (event is FetchAllLabs) {
      final res = await _labRepository.getAllLabs();
      yield state.copyWith(labsList: res.data);
    } else if (event is AddCentreFormSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        Lab lab = Lab(
            id: event.id,
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

        ResponseCallback<Lab> response;
        if (event.isUpdate) {
          response = await _labRepository.updateLab(lab, lab.id!);
        } else {
          response = await _labRepository.addLab(lab);
        }

        final createdLab = response.data;
        LimsLogger.log("*** Lab Added Successfully => $createdLab");
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
    } else if (event is OnAddCenter) {
      yield state.copyWith(
          isAddNewCenter: event.value,
          currentSelectedPriview: event.currentSelectedPriview);
    }
  }
}
