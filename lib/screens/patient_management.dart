import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lims_app/bloc/in_transit_bloc/in_transit_bloc.dart';
import 'package:lims_app/bloc/in_transit_bloc/in_transit_event.dart';
import 'package:lims_app/bloc/in_transit_bloc/in_transit_state.dart';
import 'package:lims_app/bloc/patient_bloc/patient_bloc.dart';
import 'package:lims_app/bloc/patient_bloc/patient_event.dart';
import 'package:lims_app/bloc/patient_bloc/patient_state.dart';
import 'package:lims_app/components/lims_table.dart';
import 'package:lims_app/components/buttons/redirect_button.dart';
import 'package:lims_app/components/search_header.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/test_items/redirect_to_test_menu.dart';
import 'package:lims_app/test_items/test_data.dart';
import 'package:lims_app/utils/barcode_utility.dart';
import 'package:lims_app/utils/strings/button_strings.dart';
import 'package:lims_app/utils/strings/route_strings.dart';
import 'package:lims_app/utils/strings/search_header_strings.dart';
import 'package:lims_app/utils/utils.dart';

import '../utils/color_provider.dart';
import '../utils/text_utility.dart';
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
        listener: (context, state) {},
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              BlocProvider.of<PatientBloc>(context).add(OnAddPatient());
              return true;
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: state.isAddPatient ? const AddPatient() : patientWidget(state)),
          );
        });
  }

  patientWidget(PatientState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                RedirectButton(
                    buttonText: ButtonStrings.addPatient,
                    routeName: RouteStrings.addPatient,
                    onClick: () {
                      BlocProvider.of<PatientBloc>(context).add(IsPatient(value: false));
                      BlocProvider.of<PatientBloc>(context).add(OnAddPatient(value: true));
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => AddPatient()),);
                    }),
              ],
            ),
          ),
          SearchHeader(
              headerTitle: SearchHeaderStrings.patientsListTitle,
              placeholder: SearchHeaderStrings.searchPatientsPlaceholder,
              onClickSearch: (text) {
                BlocProvider.of<PatientBloc>(context).add(OnSearch(value: text));
              }),
          LimsTable(
              columnNames: TestData.patientsColumnsList(),
              tableType: TableType.addPatient,
              onEditClick: (value) {
                BlocProvider.of<PatientBloc>(context).add(OnAddPatient(value: true, currentSelectedPriview: value));
              },
              onViewClick: (value) {
                _showPreviewDialog(value);
              },
              rowData: state.searchPatientsList),
        ].map((el) => Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: el)).toList(),
      ),
    );
  }

  /// invoice dialog
  Future<void> _showPreviewDialog(Patient patient) async {
    BlocProvider.of<InTransitBloc>(context).add(SearchPatient(patient.emailId));
    List<String> columns = ["#", "Test Name", "Sample Type", "Test Code", "Cost", "Tax%", "Total", "Barcode",""];
    print(patient.emailId);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<InTransitBloc, InTransitState>(
            builder: (context, state) {
              return AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
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
                    width: 1080,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(5))),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DataTable(
                              dataRowHeight: 85,
                              headingRowColor: MaterialStateProperty.all(Colors.black),
                              headingTextStyle: const TextStyle(color: Colors.white),
                              dataRowColor: MaterialStateProperty.all(Colors.grey.shade300),
                              columns: columns.map((el) => DataColumn(label: Text(el))).toList(),
                              rows: state.testsList!.map((test) {
                                return DataRow(cells: [
                                  DataCell(Text("${test.id}")),
                                  DataCell(Text(test.testName)),
                                  DataCell(Text(test.sampleType)),
                                  DataCell(Text(test.testCode)),
                                  DataCell(Text("${test.price}")),
                                  DataCell(Text("${test.taxPercentage}")),
                                  DataCell(Text("${test.totalPrice}")),
                                  DataCell(InkWell(
                                      onTap:(){
                                        BlocProvider.of<InTransitBloc>(context).add(ViewQrCode(test.id == state.currentVisibleQrCode? -1 : test.id!));
                                      },
                                      child: Text("View", style: TextUtility.getBoldStyle(16, color: test.id == state.currentVisibleQrCode ? Colors.red : ColorProvider.blueDarkShade)))),
                                  DataCell(
                                    Visibility(
                                      visible: test.id == state.currentVisibleQrCode,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.string(BarcodeUtility.getBarcodeSvgString(
                                            "{patientId: ${patient.id}, testId: ${test.id}")),
                                      ),
                                    ),
                                  ),
                                ]);
                              }).toList())
                        ],
                      ),
                    ),
                  ));
            },
            listener: (context, state) {});
      },
    );
  }
}
