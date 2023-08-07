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
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RedirectButton(buttonText: ButtonStrings.addPatient, routeName: RouteStrings.addPatient),
                  ],
                ),
                const SearchHeader(
                    headerTitle: SearchHeaderStrings.patientsListTitle,
                    placeholder: SearchHeaderStrings.searchPatientsPlaceholder),
                BlocBuilder<PatientBloc, PatientState>(
                  builder: (context, state) {
                    return LimsTable(columnNames: TestData.patientsColumnsList(), rowData: state.patientsList);
                  },
                ),
                redirectToTestMenu(),
              ].map((el) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: el)).toList(),
            ),
          ),
        ),
      ),
    ));
  }
}
