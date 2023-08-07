
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:lims_app/bloc/patient_bloc/patient_bloc.dart";
import "package:lims_app/bloc/patient_bloc/patient_event.dart";
import "package:lims_app/bloc/patient_bloc/patient_state.dart";
import "package:lims_app/utils/icons/icon_store.dart";
import "package:lims_app/utils/strings/add_patient_strings.dart";
import 'package:age_calculator/age_calculator.dart';

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
  final BoxConstraints _commonBoxConstraint =
      const BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 45, maxHeight: 50);
  final String _dateFormat = "yyyy-MM-dd";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<PatientBloc>();
      bloc.add(GenerateUmrNumber());
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
        children: <Row>[
          Row(
            children: [_firstNameField(), _middleNameField(), _lastNameField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20), child: el))
                .toList(),
          ),
          Row(
            children: [_datePicker(), _ageField(), _genderDropdown()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20), child: el))
                .toList(),
          ),
          Row(
            children: [_mobileNumberField(), _emailField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20), child: el))
                .toList(),
          ),
          Row(
            children: [_insuranceProviderField(), _insuranceNumberField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20), child: el))
                .toList(),
          ),
          Row(
            children: [_consultantDoctorDropdown(), _umrNumberField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20), child: el))
                .toList(),
          ),
        ],
      ),
    );
  }

  /// form text fields
  Widget _firstNameField() {
    var widget =
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('First Name'),
      const SizedBox(height: 10),
      TextFormField(
        controller: _firstNameController,
        onChanged: (value) => bloc.add(FirstNameUpdated(value)),
        decoration: InputDecoration(
            constraints: _commonBoxConstraint,
            border: const OutlineInputBorder(),
            hintText: AddPatientStrings.enterFirstName),
      )
    ]);

    return _buildBlocComponent(widget);
  }

  Widget _middleNameField() {
    var widget =
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Middle Name'),
      const SizedBox(height: 10),
      TextFormField(
        controller: _middleNameController,
        onChanged: (value) => bloc.add(MiddleNameUpdated(value)),
        decoration: InputDecoration(
            constraints: _commonBoxConstraint,
            border: const OutlineInputBorder(),
            hintText: AddPatientStrings.enterMiddleName),
      )
    ]);

    return _buildBlocComponent(widget);
  }

  Widget _lastNameField() {
    var widget =
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Last Name'),
      const SizedBox(height: 10),
      TextField(
        controller: _lastNameController,
        onChanged: (value) => bloc.add(LastNameUpdated(value)),
        decoration: InputDecoration(
            constraints: _commonBoxConstraint,
            border: const OutlineInputBorder(),
            hintText: AddPatientStrings.enterLastName),
      )
    ]);

    return _buildBlocComponent(widget);
  }

  Widget _mobileNumberField() {
    var widget =
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Mobile Number'),
      const SizedBox(height: 10),
      TextField(
        controller: _mobileNameController,
        onChanged: (value) => bloc.add(MobileNumberUpdated(int.tryParse(value) ?? 0)),
        decoration: InputDecoration(
            constraints: _commonBoxConstraint,
            border: const OutlineInputBorder(),
            hintText: AddPatientStrings.enterMobileNumber),
      )
    ]);

    return _buildBlocComponent(widget);
  }

  Widget _emailField() {
    var widget =
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Email'),
      const SizedBox(height: 10),
      TextField(
        controller: _emailIdController,
        onChanged: (value) => bloc.add(EmailUpdated(value)),
        decoration: InputDecoration(
            constraints: _commonBoxConstraint,
            border: const OutlineInputBorder(),
            hintText: AddPatientStrings.enterEmailId),
      )
    ]);

    return _buildBlocComponent(widget);
  }

  Widget _insuranceProviderField() {
    var widget =
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Insurance Provider'),
      const SizedBox(height: 10),
      TextField(
        controller: _insuranceProviderController,
        onChanged: (value) => bloc.add(InsuranceProviderUpdated(value)),
        decoration: InputDecoration(
            constraints: _commonBoxConstraint,
            border: const OutlineInputBorder(),
            hintText: AddPatientStrings.enterInsuranceProviderName),
      )
    ]);
    return _buildBlocComponent(widget);
  }

  Widget _insuranceNumberField() {
    var widget =
        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Insurance Number'),
      const SizedBox(height: 10),
      TextField(
        controller: _insuranceNumberController,
        onChanged: (value) => bloc.add(InsuranceNumberUpdated(value)),
        decoration: InputDecoration(
            constraints: _commonBoxConstraint,
            border: const OutlineInputBorder(),
            hintText: AddPatientStrings.enterInsuranceNumber),
      )
    ]);

    return _buildBlocComponent(widget);
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
            const Text(AddPatientStrings.ageText),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {},
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                  constraints: const BoxConstraints(maxWidth: 80, minWidth: 50, minHeight: 40, maxHeight: 45),
                  border: const OutlineInputBorder(),
                  hintText: state.age),
            )
          ],
        );
      },
    );
  }

  Widget _umrNumberField() {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("UMR NUMBER"),
            const SizedBox(height: 10),
            TextField(
              // controller: _umrNumberController,
              // readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                constraints: _commonBoxConstraint,
                border: const OutlineInputBorder(),
                hintText: state.umrNumber,
              ),
            )
          ],
        );
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
        const Text('Date'),
        const SizedBox(height: 10),
        TextFormField(
          controller: _datePickerTextController,
          decoration: InputDecoration(
              constraints: const BoxConstraints(maxWidth: 200, minWidth: 150, minHeight: 40, maxHeight: 45),
              border: const OutlineInputBorder(),
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
        context: context, initialDate: DateTime.now(), firstDate: DateTime(1995), lastDate: DateTime.now());
    if (pickedDate != null) {
      _datePickerTextController.text = DateFormat(_dateFormat).format(pickedDate);
      String dateText = _datePickerTextController.text;
      bloc.add(DobUpdated(dateText));
      var age = AgeCalculator.age(pickedDate).years;
      bloc.add(AgeUpdated(age.toString()));
    }
  }

  /// dropdown
  Widget _genderDropdown() {
    var widget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender'),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          icon: IconStore.downwardArrow,
          decoration: InputDecoration(
            constraints: _commonBoxConstraint,
            border: const OutlineInputBorder(),
            hintText: AddPatientStrings.gender,
          ),
          items: const <DropdownMenuItem>[
            DropdownMenuItem(value: "male", child: Text('male')),
            DropdownMenuItem(value: "female", child: Text('female'))
          ],
          onChanged: (value) {
            bloc.add(GenderUpdated(value));
          },
        )
      ],
    );

    return _buildBlocComponent(widget);
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
