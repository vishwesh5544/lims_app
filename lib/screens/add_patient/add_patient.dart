import "package:barcode/barcode.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:intl/intl.dart";
import "package:lims_app/bloc/patient_bloc/patient_bloc.dart";
import "package:lims_app/bloc/patient_bloc/patient_event.dart";
import "package:lims_app/bloc/patient_bloc/patient_state.dart";
import "package:lims_app/screens/add_patient/patient_details_form.dart";
import "package:lims_app/screens/add_patient/test_details.dart";
import "package:lims_app/utils/barcode_utility.dart";
import "package:lims_app/utils/color_provider.dart";
import "package:lims_app/utils/strings/add_patient_strings.dart";
import "package:lims_app/utils/strings/route_strings.dart";
import "package:lims_app/utils/text_utility.dart";

import "../../components/buttons/redirect_button.dart";
import "../../utils/strings/button_strings.dart";
import "../../utils/utils.dart";

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  late final PatientBloc bloc;

  final barcode = Barcode.code128(useCode128A: false, useCode128C: false);
  late final barcodeOne = barcode.toSvg("hello LIMS", width: 200, height: 100, drawText: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<PatientBloc>();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric( vertical: 20),
                child: Column(
                  children: [
                    _header(state),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          commonBtn(text: "Patient Details ", isEnable: state.isPatient,calll: (){
                            BlocProvider.of<PatientBloc>(context).add(IsPatient(value: true));
                          }),
                          commonBtn(text: "Add Test ", isEnable: !state.isPatient, calll: (){
                            BlocProvider.of<PatientBloc>(context).add(IsPatient());
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _getFormStepper(state),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  /// form stepper
  _getFormStepper(PatientState state) {
    // Step(title: const Text('Add Patient'), content: const PatientDetailsForm());
    //
    // const Step(title: Text('Add New details'), content: TestDetails());
    return SingleChildScrollView(
       child: state.isPatient? PatientDetailsForm() : TestDetails(),
    );
  }


  /// header strip
  Widget _header(PatientState state) {
    return Container(
      decoration: BoxDecoration(color: ColorProvider.blueDarkShade),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _backButton(state),
            Text(
              AddPatientStrings.headerText,
              style: TextUtility.getBoldStyle(15.0, color: Colors.white),
            ),
            Text(
              "",
              style: TextUtility.getBoldStyle(15.0, color: Colors.white),
            ),
            // _deleteButton()
          ],
        ),
      ),
    );
  }

  /// buttons
  InkWell _backButton(PatientState state) {
    return InkWell(
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onTap: () {
          // setState(() {
          //   state.isAddPatient = false;
          // });
          BlocProvider.of<PatientBloc>(context).add(FetchAllPatients());
          BlocProvider.of<PatientBloc>(context).add(OnAddPatient());
        });
  }

  ElevatedButton _deleteButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      child: Text('Delete', style: TextUtility.getBoldStyle(12.0)),
      onPressed: () {},
    );
  }

}
