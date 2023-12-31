import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
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
import "../../components/barcode_widegt.dart";
import "../../components/lims_table.dart";
import "../../utils/color_provider.dart";
import "../../utils/text_utility.dart";
import "../../utils/utils.dart";

class TestDetails extends StatefulWidget {
  const TestDetails({Key? key}) : super(key: key);

  @override
  State<TestDetails> createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  late final PatientBloc patientBloc;
  List<Test> selectedTests = [];
  List<Test> availableTests = [];
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
        commonBtn(
            text: "Submit", // "Preview Invoice"
            isEnable: true,
            calll: () {
              BlocProvider.of<PatientBloc>(context)
                  .add(GenerateInvoiceNumber());
              Future.delayed(const Duration(seconds: 1), () {
                BlocProvider.of<PatientBloc>(context).add(GenerateInvoice());
                // BlocProvider.of<InTransitBloc>(context).add(FetchAllInvoiceMapping());
                _showInvoiceDialog();

                /// refresh patients list
                BlocProvider.of<PatientBloc>(context).add(FetchAllPatients());
                BlocProvider.of<PatientBloc>(context).add(OnAddPatient());
              });
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
                titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
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
                        child: const Icon(Icons.cancel_rounded,
                            color: Colors.white),
                        onTap: () => Navigator.pop(context, "Cancel"),
                      )
                    ],
                  ),
                ),
                content: SizedBox(
                  // height: 700,
                  width: 1200,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Invoice Receipt',
                                style: TextUtility.getBoldStyle(18,
                                    color: Colors.black))
                          ],
                        ),

                        /// receipt header row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextUtility.getTextWithBoldAndPlain(
                                    "Invoice Number", state.invoiceNumber),
                                TextUtility.getTextWithBoldAndPlain(
                                    "UMR Number", state.umrNumber),
                                TextUtility.getTextWithBoldAndPlain(
                                    "Date",
                                    DateFormat("yyyy-MM-dd")
                                        .format(DateTime.now())),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextUtility.getTextWithBoldAndPlain(
                                    "Patient Name",
                                    "${state.firstName} ${state.lastName}"),
                                TextUtility.getTextWithBoldAndPlain(
                                    "Age/Sex", "${state.age}/${state.gender}"),
                                TextUtility.getTextWithBoldAndPlain(
                                    "Mobile Number",
                                    state.mobileNumber.toString()),
                              ],
                            ),
                            state.createdPatientInvoices.isNotEmpty
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: barCodeWidget(
                                      text: "",
                                      barCode: state.createdPatientInvoices
                                          .first.invoiceId
                                          .toString(),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        LimsTable(
                            columnNames: const [
                              "#",
                              "Names of the Test",
                              "Sample Type",
                              "Test Code",
                              "Cost",
                              "Tax %",
                              "Total",
                            ],
                            tableType: TableType.viewPatient,
                            tableRowHeight: 130,
                            rowData: state.selectedTests,
                            onEditClick: (value) {}),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          width: double.infinity,
                          color: Colors.black,
                          child: Row(
                            children: [
                              Text(
                                "Total Price: \$${totalPrice.toString()}",
                                style: TextUtility.getStyle(16,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: commonBtn(
                              text: "Close",
                              isEnable: true,
                              calll: () {
                                Navigator.pop(context, "Cancel");

                                /// refresh listing
                                BlocProvider.of<PatientBloc>(context)
                                    .add(FetchAllPatients());
                                BlocProvider.of<PatientBloc>(context)
                                    .add(OnAddPatient());
                                // BlocProvider.of<PatientBloc>(context).add(GenerateInvoice());
                              }),
                        ) // SvgPicture.string(barcodeOne)
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
        BlocConsumer<TestBloc, TestState>(
          listener: (context, state) {},
          builder: (context, state) {
            return DropdownButtonFormField(
              value: null,
              icon: IconStore.downwardArrow,
              decoration: InputDecoration(
                hintStyle: TextUtility.getStyle(14,
                    color: ColorProvider.darkGreyColor),
                constraints: const BoxConstraints(
                    maxWidth: 800, minWidth: 500, minHeight: 47, maxHeight: 60),
                border: getOutLineBorder(),
                focusedErrorBorder: getOutLineBorder(),
                errorBorder: getOutLineBorder(),
                disabledBorder: getOutLineBorder(),
                enabledBorder: getOutLineBorder(),
                focusedBorder: getOutLineBorder(),
                hintText: AddPatientStrings.selectTest,
              ),
              items: state.testsList.map((test) {
                return DropdownMenuItem(
                  value: test,
                  child: Text(test.testName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  if (value is Test) {}
                  totalPrice = 0;

                  if (selectedTests.isEmpty ||
                      !selectedTests.contains(value!)) {
                    selectedTests.add(value!);
                    patientBloc.add(SelectedTestsUpdated(selectedTests));
                  } else {
                    selectedTests.remove(value);
                  }

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
              border: TableBorder(
                  horizontalInside: getBorder(),
                  verticalInside: getBorder(),
                  right: getBorder(),
                  left: getBorder()),
              columns: columnNames
                  .map((name) => DataColumn(label: Text(name)))
                  .toList(),
              rows: [
                ...selectedTests.map((value) {
                  var currentIndex = selectedTests.indexOf(value) + 1;
                  return _buildDataRowForTest(value, currentIndex);
                }),
                _buildDataRowForTotalPrice(Colors.white),
                _buildDataRowForTotalPrice(Colors.black),
              ],
              showBottomBorder: true,
            )
          ],
        ),
      ],
    );
  }

  DataRow _buildDataRowForTotalPrice(Color color) {
    return DataRow(
      color: MaterialStatePropertyAll(color),
      cells: [
        const DataCell(Text("")),
        const DataCell(Text("")),
        const DataCell(Text("")),
        const DataCell(Text("")),
        const DataCell(Text("")),
        const DataCell(Text("")),
        DataCell(Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Total Price: \$$totalPrice",
            style: const TextStyle(color: Colors.white),
          ),
        )),
        const DataCell(Text("")),
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
