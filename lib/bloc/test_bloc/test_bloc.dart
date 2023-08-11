import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lims_app/bloc/test_bloc/test_event.dart';
import 'package:lims_app/bloc/test_bloc/test_state.dart';
import 'package:lims_app/models/response_callback.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/repositories/tests_repository.dart';
import 'package:lims_app/utils/form_submission_status.dart';
import 'package:lims_app/utils/lims_logger.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  final TestRepository _testRepository;

  TestBloc({required TestRepository testRepository})
      : _testRepository = testRepository,
        super(TestState());

  @override
  Stream<TestState> mapEventToState(TestEvent event) async* {
    if (event is FetchAllTests) {
      final responseCallback = await _testRepository.getAllTests();
      yield state.copyWith(testsList: responseCallback.data, searchTestsList: responseCallback.data);
    } else if (event is TestCodeUpdated) {
      yield state.copyWith(testCode: event.testCode);
    } else if (event is TestNameUpdated) {
      yield state.copyWith(testName: event.testName);
    } else if (event is DepartmentUpdated) {
      yield state.copyWith(department: event.department);
    } else if (event is TemperatureUpdated) {
      yield state.copyWith(temperature: event.temperature);
    } else if (event is TypeOfTemperatureUpdated) {
      yield state.copyWith(typeOfTemperature: event.typeOfTemperature);
    } else if (event is SampleTypeUpdated) {
      yield state.copyWith(sampleType: event.sampleType);
    } else if (event is VacutainerUpdated) {
      yield state.copyWith(vacutainer: event.vacutainer);
    } else if (event is VolumeUpdated) {
      yield state.copyWith(volume: event.volume);
    } else if (event is TypeOfVolumeUpdated) {
      yield state.copyWith(typeOfVolume: event.typeOfVolume);
    } else if (event is MethodUpdated) {
      yield state.copyWith(method: event.method);
    } else if (event is TurnAroundTimeUpdated) {
      yield state.copyWith(turnAroundTime: event.turnAroundTime);
    } else if (event is PriceUpdated) {
      yield state.copyWith(price: event.price);
    } else if (event is TaxPercentageUpdated) {
      yield state.copyWith(taxPercentage: event.taxPercentage);
    } else if (event is TotalPriceUpdated) {
      yield state.copyWith(totalPrice: event.totalPrice);
    } else if (event is IndicationsUpdated) {
      yield state.copyWith(indications: event.indications);
    } else if (event is TestSearchUpdated) {
      yield state.copyWith(searchField: event.searchField);
    } else if (event is AddTestFormSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        Test test = Test(
          id: event.id,
          testCode: event.testCode,
          testName: event.testName,
          department: event.department,
          temperature: event.temperature,
          typeOfTemperature: event.typeOfTemperature,
          sampleType: event.sampleType,
          vacutainer: event.vacutainer,
          volume: event.volume,
          typeOfVolume: event.typeOfVolume,
          method: event.method,
          turnAroundTime: event.turnAroundTime,
          price: event.price,
          taxPercentage: event.taxPercentage,
          totalPrice: event.totalPrice,
          indications: event.indications,
        );

        ResponseCallback<Test> response;
        if(event.isUpdate) {
          response = await _testRepository.updateTest(test, test.id!);
        } else {
          response = await _testRepository.addTest(test);
        }

        LimsLogger.log("*** Test Added Successfully => ${response.data}");
        yield state.copyWith(formStatus: SubmissionSuccess());
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }

    else if (event is OnSearch) {
      List<Test> data = [];

      for (Test patient in state.testsList) {
        if(patient.testName.toLowerCase().contains(event.value.trim()) ||
            patient.testCode.toLowerCase().contains(event.value.trim())){
          data.add(patient);
        }
      }

      yield state.copyWith(searchTestsList: data);
    }
    else if (event is OnAddTest) {

      yield state.copyWith(isAddTest: event.value, currentSelectedPriview: event.currentSelectedPriview);
    }
  }
}
