import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:intl/intl.dart";
import "package:lims_app/bloc/patient_bloc/patient_bloc.dart";
import "package:lims_app/bloc/patient_bloc/patient_event.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/bloc/test_bloc/test_state.dart";
import "package:lims_app/utils/strings/add_patient_strings.dart";
import "package:lims_app/models/test.dart";
import "package:lims_app/utils/icons/icon_store.dart";

import "../../bloc/patient_bloc/patient_state.dart";
import "../../components/lims_table.dart";
import "../../utils/barcode_utility.dart";
import "../../utils/color_provider.dart";
import "../../utils/text_utility.dart";
import "../../utils/utils.dart";

class TestDetails extends StatefulWidget {
  const TestDetails({Key? key}) : super(key: key);

  @override
  State<TestDetails> createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  final BoxConstraints _commonBoxConstraint =
      const BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 45, maxHeight: 50);
  late final TestBloc testBloc;
  late final PatientBloc patientBloc;
  List<Test> selectedTests = [];
  int totalPrice = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      patientBloc = context.read<PatientBloc>();
      BlocProvider.of<TestBloc>(context).add(FetchAllTests());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _testDetailsForm();
  }

  Widget _testDetailsForm() {
    return Form(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _selectTestDropdown(),
        SingleChildScrollView(child: _selectedTestsTable()),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          color: Colors.black,
          child: Row(
            children: [Text("Total Price: \$${totalPrice.toString()}", style: TextUtility.getStyle(16, color: Colors.white),)],
          ),
        ),
        commonBtn(text: "Preview Invoice", isEnable: true, calll: (){

          BlocProvider.of<PatientBloc>(context).add(GenerateInvoiceNumber());
          _showInvoiceDialog();
        }),
      ]
          .map((el) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: el,
              ))
          .toList(),
    ));
  }


  /// invoice dialog
  Future<void> _showInvoiceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<PatientBloc, PatientState>(
          builder: (context, state) {
            return AlertDialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.white,
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
                      const Text('Invoice'),
                      InkWell(
                        child: const Icon(Icons.cancel_rounded, color: Colors.white),
                        onTap: () => Navigator.pop(context, "Cancel"),
                      )
                    ],
                  ),
                ),
                content: Container(
                  // height: 700,
                  width: 1200,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Text('Invoice Receipt', style: TextUtility.getBoldStyle(18,color: Colors.black))],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextUtility.getTextWithBoldAndPlain("Invoice Number", state.invoiceNumber),
                                TextUtility.getTextWithBoldAndPlain("UMR Number", state.umrNumber),
                                TextUtility.getTextWithBoldAndPlain(
                                    "Date", DateFormat("yyyy-MM-dd").format(DateTime.now())),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextUtility.getTextWithBoldAndPlain(
                                    "Patient Name", "${state.firstName} ${state.lastName}"),
                                TextUtility.getTextWithBoldAndPlain("Age/Sex", "${state.age}/${state.gender}"),
                                TextUtility.getTextWithBoldAndPlain("MobileNumber", state.mobileNumber.toString()),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 2
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(5))
                              ),
                              child: SvgPicture.string(BarcodeUtility.getBarcodeSvgString(
                                  "${state.createdPatient?.id}${state.invoiceNumber}"), width: 150, height: 75),
                            )
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     SingleChildScrollView(
                        //         child: SizedBox(
                        //           height: 200,
                        //           width: 400,
                        //           child: ListView(
                        //             shrinkWrap: true,
                        //             children: state.selectedTests.map((e) {
                        //               return Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),
                        //                 child: Row(
                        //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //                   children: [
                        //                     Text("${e.testName} => ${e.id}"),
                        //                     SvgPicture.string(BarcodeUtility.getBarcodeSvgString(
                        //                         "${state.createdPatient?.id}${state.invoiceNumber}${e.id}")),
                        //                   ],
                        //                 ),);
                        //             }).toList(),
                        //           ),
                        //         ))
                        //   ],
                        // ),

                        LimsTable(
                            columnNames: const ["#","Names of the Test", "Sample Type",
                              "Test Code", "Cost", "Tax %", "Total",],
                            tableType: TableType.viewPatient,
                            tableRowHeight: 85,
                            rowData: state.selectedTests, onEditClick: (value){

                        }),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          width: double.infinity,
                          color: Colors.black,
                          child: Row(
                            children: [Text("Total Price: \$${totalPrice.toString()}", style: TextUtility.getStyle(16, color: Colors.white),)],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: commonBtn(text: "Generate Invoice", isEnable: true, calll: (){
                            BlocProvider.of<PatientBloc>(context).add(GenerateInvoice());
                          }),
                        )// SvgPicture.string(barcodeOne)
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }



  /// dropdown
  Widget _selectTestDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Test'),
        const SizedBox(height: 10),
        BlocBuilder<TestBloc, TestState>(
          builder: (context, state) {
            return DropdownButtonFormField(
              icon: IconStore.downwardArrow,
              decoration: const InputDecoration(
                constraints: BoxConstraints(maxWidth: 500, minWidth: 400, minHeight: 60, maxHeight: 70),
                border: OutlineInputBorder(),
                hintText: AddPatientStrings.selectTest,
              ),
              items: state.testsList.map((test) {
                return DropdownMenuItem(value: test, child: Text(test.testName));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  totalPrice = 0;
                  selectedTests.add(value!);
                  patientBloc.add(SelectedTestsUpdated(selectedTests));
                  for (var test in selectedTests) {
                    totalPrice += test.price;
                  }
                });
              },
            );
          },
        )
      ],
    );
  }

  /// tests table
  Widget _selectedTestsTable() {
    List<String> columnNames = [
      "#",
      "Test code",
      "Test name",
      "Department",
      "Sample type",
      "Turn Around Time (TAT)",
      "Price",
      "Actions"
    ];

    return Column(
      children: [
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.black),
              headingTextStyle: const TextStyle(color: Colors.white),
              dataRowColor: MaterialStateProperty.all(Colors.white),
              dividerThickness: 0.2,
              headingRowHeight: 50,
              border: TableBorder(horizontalInside: getBorder(), verticalInside: getBorder(), right: getBorder(), left: getBorder()),
              columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
              rows: selectedTests.map((value) {
                var currentIndex = selectedTests.indexOf(value) + 1;
                return _buildDataRowForTest(value, currentIndex);
              }).toList(),
              showBottomBorder: true,
            )
          ],
        ),
      ],
    );
  }

  DataRow _buildDataRowForTest(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text("${test.id ?? currentIndex.toString()}")),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.testName)),
      DataCell(Text(test.department)),
      DataCell(Text(test.sampleType)),
      DataCell(Text(test.turnAroundTime)),
      DataCell(Text(test.price.toString())),
      DataCell(InkWell(
        child: const Icon(Icons.delete),
        onTap: () {
          setState(() {
            selectedTests.remove(test);
            patientBloc.add(SelectedTestsUpdated(selectedTests));
            if (selectedTests.isEmpty) {
              totalPrice = 0;
            } else {
              totalPrice = totalPrice - test.price;
            }
          });
        },
      ))
    ]);
  }
}
