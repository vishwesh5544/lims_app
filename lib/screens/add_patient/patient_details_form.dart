import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:lims_app/bloc/patient_bloc/patient_bloc.dart";
import "package:lims_app/bloc/patient_bloc/patient_event.dart";
import "package:lims_app/bloc/patient_bloc/patient_state.dart";
import "package:lims_app/utils/icons/icon_store.dart";
import "package:lims_app/utils/screen_helper.dart";
import "package:lims_app/utils/strings/add_patient_strings.dart";
import 'package:age_calculator/age_calculator.dart';
import "../../components/common_disabled_field.dart";
import "../../components/common_dropdown.dart";
import "../../components/common_edit_text_filed.dart";
import "../../utils/color_provider.dart";
import "../../utils/text_utility.dart";
import "../../utils/utils.dart";

class PatientDetailsForm extends StatefulWidget {
  const PatientDetailsForm({Key? key}) : super(key: key);

  @override
  State<PatientDetailsForm> createState() => _PatientDetailsFormState();
}

class _PatientDetailsFormState extends State<PatientDetailsForm> {
  late final PatientBloc bloc;
  final TextEditingController _datePickerTextController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNameController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _insuranceProviderController = TextEditingController();
  final TextEditingController _insuranceNumberController = TextEditingController();
  final TextEditingController _umrNumberController = TextEditingController();
  final TextEditingController _consultedDoctorController = TextEditingController();
  final BoxConstraints _commonBoxConstraint =
      const BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 45, maxHeight: 50);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<PatientBloc>();
      bloc.add(GenerateUmrNumber());

      if (bloc.state.isAddPatient && bloc.state.currentSelectedPriview != -1) {
        bloc.add(GenderUpdated(bloc.state.patientsList[bloc.state.currentSelectedPriview].gender));

        bloc.add(FirstNameUpdated(bloc.state.patientsList[bloc.state.currentSelectedPriview].firstName));
        bloc.add(MiddleNameUpdated(bloc.state.patientsList[bloc.state.currentSelectedPriview].middleName));
        bloc.add(LastNameUpdated(bloc.state.patientsList[bloc.state.currentSelectedPriview].lastName));
        bloc.add(MobileNumberUpdated(bloc.state.patientsList[bloc.state.currentSelectedPriview].mobileNumber));
        bloc.add(EmailUpdated(bloc.state.patientsList[bloc.state.currentSelectedPriview].emailId));
        bloc.add(InsuranceProviderUpdated(bloc.state.patientsList[bloc.state.currentSelectedPriview].insuraceProvider));
        bloc.add(InsuranceNumberUpdated(bloc.state.patientsList[bloc.state.currentSelectedPriview].insuraceNumber));
        bloc.add(ConsultedDoctorUpdated(bloc.state.patientsList[bloc.state.currentSelectedPriview].consultedDoctor));

        _datePickerTextController.text = bloc.state.patientsList[bloc.state.currentSelectedPriview].dob;

        String dateText = _datePickerTextController.text;
        bloc.add(DobUpdated(dateText));
        var age = bloc.state.patientsList[bloc.state.currentSelectedPriview].age;
        bloc.add(AgeUpdated(age.toString()));

        _firstNameController.text = bloc.state.patientsList[bloc.state.currentSelectedPriview].firstName;
        _middleNameController.text = bloc.state.patientsList[bloc.state.currentSelectedPriview].middleName;
        _lastNameController.text = bloc.state.patientsList[bloc.state.currentSelectedPriview].lastName;
        _mobileNameController.text = bloc.state.patientsList[bloc.state.currentSelectedPriview].mobileNumber.toString();
        _emailIdController.text = bloc.state.patientsList[bloc.state.currentSelectedPriview].emailId;
        _insuranceProviderController.text = bloc.state.patientsList[bloc.state.currentSelectedPriview].insuraceProvider;
        _insuranceNumberController.text = bloc.state.patientsList[bloc.state.currentSelectedPriview].insuraceNumber;
        _umrNumberController.text = bloc.state.patientsList[bloc.state.currentSelectedPriview].consultedDoctor;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _patientDetailsForm();
  }

  /// forms
  Form _patientDetailsForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [_firstNameField(), _middleNameField(), _lastNameField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: el))
                .toList(),
          ),
          Row(
            children: [_datePicker(), _ageField(), _genderDropdown()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: el))
                .toList(),
          ),
          Row(
            children: [_mobileNumberField(), _emailField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: el))
                .toList(),
          ),
          Row(
            children: [_insuranceProviderField(), _insuranceNumberField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: el))
                .toList(),
          ),
          Row(
            children: [_consultedDoctorField(), _umrNumberField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: el))
                .toList(),
          ),
          commonBtn(
              text: "Next",
              isEnable: true,
              calll: () {
                if (/*!bloc.state.isAddPatient &&*/ bloc.state.currentSelectedPriview != -1) {
                  int userId = bloc.state.patientsList[bloc.state.currentSelectedPriview].id!;
                  // update?
                  BlocProvider.of<PatientBloc>(context)
                      .add(AddPatientFormSubmitted(isUpdate: true, userId: userId));

                } else {
                  BlocProvider.of<PatientBloc>(context).add(AddPatientFormSubmitted(isUpdate: false));
                }

                if (/*bloc.state.isAddPatient && */bloc.state.currentSelectedPriview == -1) {
                  BlocProvider.of<PatientBloc>(context).add(IsPatient());
                }else {
                  ScreenHelper.showAlertPopup("Patient updated successfully ", context).then((value){
                    ///to refresh listing screen.
                    BlocProvider.of<PatientBloc>(context).add(FetchAllPatients());
                    BlocProvider.of<PatientBloc>(context).add(OnAddPatient());
                  });
                }
              }),
        ],
      ),
    );
  }

  /// form text fields
  Widget _firstNameField() {
    // var widget =
    //     Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   const Text('First Name'),
    //   const SizedBox(height: 10),
    //   TextFormField(
    //     controller: _firstNameController,
    //     onChanged: (value) => bloc.add(FirstNameUpdated(value)),
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint,
    //         border: const OutlineInputBorder(),
    //         hintText: AddPatientStrings.enterFirstName),
    //   )
    // ]);

    return _buildBlocComponent(CommonEditText(title: 'First Name', hintText: AddPatientStrings.enterFirstName, onChange: (value){
      bloc.add(FirstNameUpdated(value));
    },controller: _firstNameController,));
  }

  Widget _middleNameField() {
    // var widget =
    //     Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   const Text('Middle Name'),
    //   const SizedBox(height: 10),
    //   TextFormField(
    //     controller: _middleNameController,
    //     onChanged: (value) => bloc.add(MiddleNameUpdated(value)),
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint,
    //         border: const OutlineInputBorder(),
    //         hintText: AddPatientStrings.enterMiddleName),
    //   )
    // ]);

    return _buildBlocComponent(CommonEditText(title: 'Middle Name', hintText: AddPatientStrings.enterMiddleName, onChange: (value){
      bloc.add(MiddleNameUpdated(value));
    },controller: _middleNameController,));
  }

  Widget _lastNameField() {
    // var widget =
    //     Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   const Text('Last Name'),
    //   const SizedBox(height: 10),
    //   TextField(
    //     controller: _lastNameController,
    //     onChanged: (value) => bloc.add(LastNameUpdated(value)),
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint,
    //         border: const OutlineInputBorder(),
    //         hintText: AddPatientStrings.enterLastName),
    //   )
    // ]);

    return _buildBlocComponent(CommonEditText(title: 'Last Name',
        controller: _lastNameController,
      hintText: AddPatientStrings.enterLastName, onChange: (value){
      bloc.add(LastNameUpdated(value));
    }));
  }

  Widget _mobileNumberField() {
    // var widget =
    //     Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   const Text('Mobile Number'),
    //   const SizedBox(height: 10),
    //   TextField(
    //     controller: _mobileNameController,
    //     onChanged: (value) => bloc.add(MobileNumberUpdated(int.tryParse(value) ?? 0)),
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint,
    //         border: const OutlineInputBorder(),
    //         hintText: AddPatientStrings.enterMobileNumber),
    //   )
    // ]);

    return _buildBlocComponent(CommonEditText(title: 'Mobile Number',
        controller: _mobileNameController,
        hintText: AddPatientStrings.enterMobileNumber, onChange: (value){
          bloc.add(MobileNumberUpdated(int.parse(value)));
        }));
  }

  Widget _emailField() {
    // var widget =
    //     Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   const Text('Email'),
    //   const SizedBox(height: 10),
    //   TextField(
    //     controller: _emailIdController,
    //     onChanged: (value) => bloc.add(EmailUpdated(value)),
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint,
    //         border: const OutlineInputBorder(),
    //         hintText: AddPatientStrings.enterEmailId),
    //   )
    // ]);

    return _buildBlocComponent(CommonEditText(title: 'Email',
        controller: _emailIdController,
        hintText: AddPatientStrings.enterEmailId, onChange: (value){
          bloc.add(EmailUpdated(value));
        }));
  }

  Widget _insuranceProviderField() {
    // var widget =
    //     Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   const Text('Insurance Provider'),
    //   const SizedBox(height: 10),
    //   TextField(
    //     controller: _insuranceProviderController,
    //     onChanged: (value) => bloc.add(InsuranceProviderUpdated(value)),
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint,
    //         border: const OutlineInputBorder(),
    //         hintText: AddPatientStrings.enterInsuranceProviderName),
    //   )
    // ]);
    return _buildBlocComponent(CommonEditText(title: 'Insurance Provider',
        controller: _insuranceProviderController,
        hintText: AddPatientStrings.enterInsuranceProviderName, onChange: (value){
          bloc.add(InsuranceProviderUpdated(value));
        }));
  }

  Widget _insuranceNumberField() {
    // var widget =
    //     Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   const Text('Insurance Number'),
    //   const SizedBox(height: 10),
    //   TextField(
    //     controller: _insuranceNumberController,
    //     onChanged: (value) => bloc.add(InsuranceNumberUpdated(value)),
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint,
    //         border: const OutlineInputBorder(),
    //         hintText: AddPatientStrings.enterInsuranceNumber),
    //   )
    // ]);

    return _buildBlocComponent(CommonEditText(title: 'Insurance Number',
        controller: _insuranceNumberController,
        hintText: AddPatientStrings.enterInsuranceNumber, onChange: (value){
          bloc.add(InsuranceNumberUpdated(value));
        }));
  }

  Widget _consultedDoctorField() {
    // var widget =
    // Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
    //   const Text('Consulted Doctor'),
    //   const SizedBox(height: 10),
    //   TextField(
    //     controller: _consultedDoctorController,
    //     onChanged: (value) => bloc.add(ConsultedDoctorUpdated(value)),
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint,
    //         border: const OutlineInputBorder(),
    //         hintText: "Enter Doctor Name"),
    //   )
    // ]);

    return _buildBlocComponent(CommonEditText(title: 'Consulted Doctor',
        controller: _consultedDoctorController,
        hintText: "Enter Doctor Name", onChange: (value){
          bloc.add(ConsultedDoctorUpdated(value));
        }));
  }


  /// bloc builder
  Widget _buildBlocComponent(Widget widget) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        return widget;
      },
    );
  }

  /// disabled text fields
  Widget _ageField() {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AddPatientStrings.ageText, style: TextUtility.getStyle(13)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                  color: ColorProvider.lightGreyColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5))
              ),
              child: TextField(
                onChanged: (value) {},
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                    constraints: const BoxConstraints(maxWidth: 80, minWidth: 50, minHeight: 40, maxHeight: 45),
                    border: const OutlineInputBorder(),
                    hintText: state.age),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _umrNumberField() {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        return CommonGreyFiled(title: "UMR Number", value: state.umrNumber);
      },
    );
  }

  /// datepicker
  Widget _datePicker() {
    String dateText = _datePickerTextController.text;
    var widget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Date", style: TextUtility.getStyle(13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _datePickerTextController,
          decoration: InputDecoration(
              hintStyle: TextUtility.getStyle(14, color: ColorProvider.darkGreyColor),
              constraints: const BoxConstraints(maxWidth: 160, minWidth: 150, minHeight: 35, maxHeight: 50),
              border: getOutLineBorder(),
              focusedErrorBorder: getOutLineBorder(),
              errorBorder: getOutLineBorder(),
              disabledBorder: getOutLineBorder(),
              enabledBorder: getOutLineBorder(),
              focusedBorder: getOutLineBorder(),
              suffixIcon: const Icon(Icons.calendar_today),
              hintText: dateText.isNotEmpty ? dateText : "Select Date"),
          readOnly: true,
          onTap: () async => _selectDate(),
          onChanged: (value) {},
        )
      ],
    );

    return _buildBlocComponent(widget);
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(1947), lastDate: DateTime.now());
    if (pickedDate != null) {
      _datePickerTextController.text = DateFormat(dateFormat).format(pickedDate);
      String dateText = _datePickerTextController.text;
      bloc.add(DobUpdated(dateText));
      var age = AgeCalculator.age(pickedDate).years;
      bloc.add(AgeUpdated(age.toString()));
    }
  }

  /// dropdown
  Widget _genderDropdown() {
    // var widget = Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text("Gender", style: TextUtility.getStyle(13)),
    //     const SizedBox(height: 6),
    //     DropdownButtonFormField(
    //       icon: IconStore.downwardArrow,
    //       decoration: InputDecoration(
    //         constraints: _commonBoxConstraint,
    //         border: const OutlineInputBorder(),
    //         hintText: AddPatientStrings.gender,
    //       ),
    //       items: const <DropdownMenuItem>[
    //         DropdownMenuItem(value: "male", child: Text('male')),
    //         DropdownMenuItem(value: "female", child: Text('female'))
    //       ],
    //       onChanged: (value) {
    //         bloc.add(GenderUpdated(value));
    //       },
    //     )
    //   ],
    // );

    return _buildBlocComponent(CommonDropDown(title: "Gender", hintText: AddPatientStrings.gender,
        list: const ["male", "female"], onSubmit: (value){
          bloc.add(GenderUpdated(value));
        }));
  }

  Widget _consultantDoctorDropdown() {
    var widget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Consultant Doctor'),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          icon: IconStore.downwardArrow,
          decoration: InputDecoration(
            constraints: _commonBoxConstraint,
            border: const OutlineInputBorder(),
            hintText: AddPatientStrings.selectDoctor,
          ),
          items: const <DropdownMenuItem>[
            DropdownMenuItem(value: "male", child: Text('male')),
            DropdownMenuItem(value: "female", child: Text('female'))
          ],
          onChanged: (value) {
            bloc.add(ConsultedDoctorUpdated(value));
          },
        )
      ],
    );

    return _buildBlocComponent(widget);
  }
}
