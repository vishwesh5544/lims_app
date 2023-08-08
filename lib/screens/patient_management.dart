import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lims_app/bloc/patient_bloc/patient_bloc.dart';
import 'package:lims_app/bloc/patient_bloc/patient_event.dart';
import 'package:lims_app/bloc/patient_bloc/patient_state.dart';
import 'package:lims_app/components/lims_table.dart';
import 'package:lims_app/components/buttons/redirect_button.dart';
import 'package:lims_app/components/search_header.dart';
import 'package:lims_app/test_items/redirect_to_test_menu.dart';
import 'package:lims_app/test_items/test_data.dart';
import 'package:lims_app/utils/strings/button_strings.dart';
import 'package:lims_app/utils/strings/route_strings.dart';
import 'package:lims_app/utils/strings/search_header_strings.dart';
import 'package:lims_app/utils/utils.dart';

import 'add_patient/add_patient.dart';

class PatientManagement extends StatefulWidget {
  const PatientManagement({Key? key}) : super(key: key);

  @override
  State<PatientManagement> createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement> {
  final test = TestData();
  static List<String> columnNames = [
    "#",
    "UMR Number",
    "Patient Name",
    "Consulted Doctor",
    "Insurance Number",
    "Mobile Number",
    "Email ID",
    "Actions"
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<PatientBloc>(context).add(FetchAllPatients());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientBloc, PatientState>(
        listener: (context, state) {

        },
        builder: (context, state) {
        return WillPopScope(
            onWillPop: () async {
              BlocProvider.of<PatientBloc>(context).add(OnAddPatient());
              return true;
            },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: state.isAddPatient? const AddPatient() : patientWidget(state)
          ),
        );
      }
    );
  }

  patientWidget(PatientState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RedirectButton(buttonText: ButtonStrings.addPatient, routeName: RouteStrings.addPatient, onClick: (){
                BlocProvider.of<PatientBloc>(context).add(OnAddPatient(value: true));
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => AddPatient()),);

              }),
            ],
          ),
          SearchHeader(
              headerTitle: SearchHeaderStrings.patientsListTitle,
              placeholder: SearchHeaderStrings.searchPatientsPlaceholder,
              onClickSearch: (text){
                BlocProvider.of<PatientBloc>(context).add(OnSearch(value: text));
              }),
          LimsTable(columnNames: TestData.patientsColumnsList(),
              tableType: TableType.addPatient,
              onEditClick: (value){
                BlocProvider.of<PatientBloc>(context).add(OnAddPatient(value: true));

              },
              rowData: state.searchPatientsList),
        ].map((el) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: el)).toList(),
      ),
    );
  }
}
