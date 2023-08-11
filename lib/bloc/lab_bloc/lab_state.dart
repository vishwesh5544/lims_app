import 'package:lims_app/models/lab.dart';
import 'package:lims_app/models/lab_test_detail.dart';
import 'package:lims_app/utils/form_submission_status.dart';

class LabState {
  final int? id;
  final String labName;
  final String emailId;
  final String contactNumber;
  final String addressOne;
  final String addressTwo;
  final String country;
  final String state;
  final String city;
  final String unitType;
  final List<LabTestDetail> testDetails;
  final FormSubmissionStatus formStatus;
  bool isAddNewCenter = false;
  int currentSelectedPriview = -1;
  final List<Lab> labsList;

  LabState(
      {this.id,
      this.labName = '',
      this.emailId = '',
      this.contactNumber = '',
      this.addressOne = '',
      this.addressTwo = '',
      this.country = '',
      this.state = '',
      this.city = '',
      this.unitType = '',
      this.testDetails = const [],
      this.labsList = const [],
      this.isAddNewCenter = false,
      this.currentSelectedPriview = -1,
      this.formStatus = const InitialFormStatus()});

  LabState copyWith(
      {int? id,
      String? labName,
      String? emailId,
      String? contactNumber,
      String? addressOne,
      String? addressTwo,
      String? country,
      String? state,
      String? city,
      String? unitType,
      List<LabTestDetail>? testDetails,
      FormSubmissionStatus? formStatus,
        bool? isAddNewCenter,
        int? currentSelectedPriview ,
      List<Lab>? labsList}) {
    return LabState(
        id: id ?? this.id,
        labName: labName ?? this.labName,
        emailId: emailId ?? this.labName,
        contactNumber: contactNumber ?? this.contactNumber,
        addressOne: addressOne ?? this.addressOne,
        addressTwo: addressTwo ?? this.addressTwo,
        country: country ?? this.country,
        state: state ?? this.state,
        city: city ?? this.city,
        unitType: unitType ?? this.unitType,
        testDetails: testDetails ?? this.testDetails,
        formStatus: formStatus ?? this.formStatus,
        isAddNewCenter: isAddNewCenter ?? this.isAddNewCenter,
        currentSelectedPriview: currentSelectedPriview ?? this.currentSelectedPriview,
        labsList: labsList ?? this.labsList);
  }
}
