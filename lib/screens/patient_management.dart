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

import '../utils/color_provider.dart';
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
                BlocProvider.of<PatientBloc>(context).add(OnAddPatient(value: true,currentSelectedPriview: value));
              },
              onViewClick: (value){
            showToast(msg: value);
              },
              rowData: state.searchPatientsList),
        ].map((el) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: el)).toList(),
      ),
    );
  }


  /// invoice dialog
  Future<void> _showPreviewDialog(value) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            insetPadding: EdgeInsets.zero,
            titleTextStyle: const TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold, fontSize: 20.0),
            titlePadding: EdgeInsets.zero,
            title: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: ColorProvider.blueDarkShade),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(),
                  const Text('Test Details'),
                  InkWell(
                    child: const Icon(Icons.cancel_rounded, color: Colors.white),
                    onTap: () => Navigator.pop(context, "Cancel"),
                  )
                ],
              ),
            ),
            content: Container(
              // height: 600,
              width: 600,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey,
                      width: 1
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(5))
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                  ],
                ),
              ),
            ));
      },
    );
  }
}
