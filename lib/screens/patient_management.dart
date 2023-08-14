import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:lims_app/test_items/test_data.dart';
import 'package:lims_app/utils/strings/button_strings.dart';
import 'package:lims_app/utils/strings/route_strings.dart';
import 'package:lims_app/utils/strings/search_header_strings.dart';
import 'package:lims_app/utils/utils.dart';
import '../components/barcode_widegt.dart';
import '../utils/color_provider.dart';
import '../utils/text_utility.dart';
import 'add_patient/add_patient.dart';

class PatientManagement extends StatefulWidget {
  const PatientManagement({Key? key}) : super(key: key);

  @override
  State<PatientManagement> createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement> {
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
      },
    );
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
                      BlocProvider.of<PatientBloc>(context).add(OnAddPatient(value: true));
                      BlocProvider.of<PatientBloc>(context).add(IsPatient(value: true));
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
                BlocProvider.of<PatientBloc>(context).add(IsPatient(value: true));
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
    List<String> columns = ["#", "Test Name", "Sample Type", "Test Code", "Cost", "Tax%", "Total", "Barcode", ""];
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
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(5))),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocConsumer<InTransitBloc, InTransitState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              final patientMapping =
                                  state.invoiceMappings?.where((element) => element.patientId == patient.id).toList();
                              if (patientMapping != null && patientMapping.isNotEmpty) {
                                var inoviceId = patientMapping.first.invoiceId;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Invoice ID", style: TextUtility.getBoldStyle(15.0, color: Colors.black)),
                                          barCodeWidget(
                                            text: '',
                                            barCode: "$inoviceId",
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          DataTable(
                              dataRowMinHeight: 120,
                              dataRowMaxHeight: 120,
                              dividerThickness: 0.2,
                              headingRowHeight: 90,
                              headingRowColor: MaterialStateProperty.all(Colors.black),
                              headingTextStyle: const TextStyle(color: Colors.white),
                              dataRowColor: MaterialStateProperty.all(ColorProvider.lightGreyColor),
                              // border: TableBorder(horizontalInside: getBorder(),verticalInside: getBorder(),right: getBorder(),left: getBorder()),
                              columns: columns.map((el) => DataColumn(label: Text(el))).toList(),
                              rows: state.testsList!.indexed.map((testMap) {
                                final (index, test) = testMap;

                                return DataRow(
                                    color: test.id == state.currentVisibleQrCode
                                        ? MaterialStateProperty.all(ColorProvider.lightGreyColor)
                                        : MaterialStateProperty.all(Colors.white),
                                    cells: [
                                      DataCell(Text("${index + 1}")),
                                      DataCell(Text(test.testName)),
                                      DataCell(Text(test.sampleType)),
                                      DataCell(Text(test.testCode)),
                                      DataCell(Text("${test.price}")),
                                      DataCell(Text("${test.taxPercentage}")),
                                      DataCell(Text("${test.totalPrice}")),
                                      DataCell(InkWell(
                                          onTap: () {
                                            BlocProvider.of<InTransitBloc>(context)
                                                .add(ViewQrCode(test.id == state.currentVisibleQrCode ? -1 : test.id!));
                                          },
                                          child: Text("View",
                                              style: TextUtility.getBoldStyle(16,
                                                  color: test.id == state.currentVisibleQrCode
                                                      ? Colors.red
                                                      : ColorProvider.blueDarkShade)))),
                                      DataCell(
                                        Visibility(
                                          visible: test.id == state.currentVisibleQrCode,
                                          maintainSize: true,
                                          maintainAnimation: true,
                                          maintainState: true,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: BlocConsumer<InTransitBloc, InTransitState>(
                                              listener: (context, state) {},
                                              builder: (context, state) {
                                                if (state.invoiceMappings != null &&
                                                    state.invoiceMappings!.isNotEmpty) {
                                                  var ptid = state.invoiceMappings
                                                      ?.firstWhere((element) => element.testId == test.id)
                                                      .ptid;
                                                  return barCodeWidget(
                                                    text: test.testName,
                                                    barCode: "$ptid",
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            ),
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
