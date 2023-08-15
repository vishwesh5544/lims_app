import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_bloc.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_event.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_state.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/models/invoice_mapping.dart";
import "package:lims_app/utils/utils.dart";
import "../components/common_header.dart";

class TestStatus extends StatefulWidget {
  const TestStatus({Key? key}) : super(key: key);

  @override
  State<TestStatus> createState() => _TestStatusState();
}

class _TestStatusState extends State<TestStatus> {
  TextEditingController textController = TextEditingController();
  late final InTransitBloc bloc;

  final TextEditingController _fromDatePickerTextController = TextEditingController();
  final TextEditingController _toDatePickerTextController = TextEditingController();

  static List<String> columnNames = [
    "#",
    "Patient\nName",
    "UMR Number",
    "Test Name",
    "Test Code",
    // "Sample Collection Code",
    // "Process Unit",
    "Status",
    // "action"
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<TestBloc>(context).add(FetchAllTests());
      bloc = context.read<InTransitBloc>();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InTransitBloc, InTransitState>(
        listener: (context, state) {},
        builder: (context, state) {
          return WillPopScope(
              onWillPop: () async {
                BlocProvider.of<TestBloc>(context).add(OnAddTest());
                return true;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonHeader(title: "Test Status"),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ///search
                            commonSearchArea(
                                title: "Search Status",
                                hint: "Search by Patient Name/UMR/ Test/ Processing Unit/ Sample Collection Centre",
                                textController: textController,
                                onSubmit: (value) {
                                  bloc.add(SearchPatient(value));

                                  bloc.add(FetchSearchResults(value));
                                  for (var result in state.searchResults!) {
                                    debugPrint(result.toJson().toString());
                                  }
                                }),

                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: commonBtn(text: "Search", isEnable: true, calll: () {}),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DataTable(
                                    // dataRowHeight: 85,
                                    headingRowColor: MaterialStateProperty.all(Colors.black),
                                    headingTextStyle: const TextStyle(color: Colors.white),
                                    dataRowColor: MaterialStateProperty.all(Colors.white),
                                    dividerThickness: 0.2,
                                    border: TableBorder(
                                        horizontalInside: getBorder(),
                                        verticalInside: getBorder(),
                                        right: getBorder(),
                                        left: getBorder()),
                                    columns: columnNames
                                        .map((name) => DataColumn(
                                                label: Text(
                                              name,
                                              maxLines: 2,
                                            )))
                                        .toList(),
                                    rows: state.invoiceMappings!.map((InvoiceMapping mapping) {
                                      if (state.patient == null ||
                                          state.invoiceMappings!.isEmpty ||
                                          state.testsList!.isEmpty) {
                                        return const DataRow(cells: [
                                          DataCell(SizedBox(height: 0, width: 0,)),
                                          DataCell(SizedBox(height: 0, width: 0,)),
                                          DataCell(SizedBox(height: 0, width: 0,)),
                                          DataCell(SizedBox(height: 0, width: 0,)),
                                          DataCell(SizedBox(height: 0, width: 0,)),
                                          DataCell(SizedBox(height: 0, width: 0,)),
                                        ]);
                                      }
                                      var invoiceId = mapping.id;
                                      var patientName =
                                          "${state.patient?.firstName ?? ''} ${state.patient?.middleName ?? ''} "
                                          "${state.patient?.lastName ?? ''}";
                                      var umrNumber = state.patient?.umrNumber ?? "";
                                      var test = state.testsList?.firstWhere((test) => test.id == mapping.testId);
                                      var testName = test?.testName;
                                      var testCode = test?.testCode;
                                      var statusText = "";
                                      if (mapping.status == 0) {
                                        statusText = "Patient Created";
                                      } else if (mapping.status == 1) {
                                        statusText = "Initiated";
                                      } else if (mapping.status == 2) {
                                        statusText = "Collected";
                                      } else if (mapping.status == 3) {
                                        statusText = "In Transit";
                                      } else if (mapping.status == 4) {
                                        statusText = "Processing";
                                      } else if (mapping.status == 5) {
                                        statusText = "Completed";
                                      }

                                      debugPrint("*** => $patientName");

                                      return DataRow(cells: [
                                        DataCell(Text("$invoiceId")),
                                        DataCell(Text(patientName)),
                                        DataCell(Text(umrNumber)),
                                        DataCell(Text("$testName")),
                                        DataCell(Text("$testCode")),
                                        DataCell(Row(
                                          children: [
                                            SizedBox(width: 80, child: Text(statusText)),
                                            // commonIconBtn(
                                            //     text: "Report",
                                            //     icon: const Icon(
                                            //         Icons.print_outlined,
                                            //         color: Colors.white,
                                            //         size: 18),
                                            //     isEnable: true,
                                            //     calll: () {}),
                                          ],
                                        )),
                                      ]);
                                    }).toList()),
                              ],
                            )
                          ],
                        ),
                      ),

                      // Container(
                      //   margin: EdgeInsets.symmetric(vertical: 10),
                      //   child: commonBtn(
                      //       text: "Update",
                      //       isEnable: true,
                      //       calll: () {
                      //         showToast(msg: "Update");
                      //       }),
                      // ),
                    ],
                  ),
                ),
              ));
        });
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(1995), lastDate: DateTime.now());
    if (pickedDate != null) {
      _fromDatePickerTextController.text = DateFormat(dateFormat).format(pickedDate);
      // String dateText = _fromDatePickerTextController.text;
      // bloc.add(DobUpdated(dateText));
      // var age = AgeCalculator.age(pickedDate).years;
      // bloc.add(AgeUpdated(age.toString()));
    }
  }
}
