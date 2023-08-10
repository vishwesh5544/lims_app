import "dart:js_interop";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_bloc.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_event.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_state.dart";
import "package:lims_app/models/lab.dart";
import "package:lims_app/models/patient.dart";
import "package:lims_app/models/test.dart";
import "package:lims_app/utils/pdf_utility.dart";
import "package:lims_app/utils/utils.dart";
import "package:printing/printing.dart";

import "../utils/barcode_utility.dart";
import "../utils/icons/icon_store.dart";
import "../utils/strings/add_patient_strings.dart";

enum TableType { addPatient, addTest, viewPatient, lab, inTransit, process, testStatus, sample }

class LimsTable extends StatelessWidget {
  LimsTable(
      {required this.columnNames,
      required this.rowData,
      required this.tableType,
      required this.onEditClick,
      this.conditionalButton,
      this.onViewClick,
      this.onSubmit,
      this.onPrintPdf,
      super.key});

  final List<String> columnNames;
  final List<dynamic> rowData;
  TableType tableType;
  Function onEditClick;
  Function? onViewClick;
  Function? onSubmit;
  Function? onPrintPdf;
  Widget? conditionalButton;

  @override
  Widget build(BuildContext context) {
    // TODO: create builder for ListView > DataTable
    return Column(
      children: [
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            DataTable(
              dataRowHeight: 85,
              headingRowColor: MaterialStateProperty.all(Colors.black),
              headingTextStyle: const TextStyle(color: Colors.white),
              dataRowColor: MaterialStateProperty.all(Colors.grey.shade300),
              columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
              rows: rowData.map((value) {
                var currentIndex = rowData.indexOf(value) + 1;
                // TODO: bring value type check to top level
                if (tableType == TableType.addPatient) {
                  return _buildDataRowForPatient(value, currentIndex);
                } else if (tableType == TableType.addTest) {
                  return _buildDataRowForTest(value, currentIndex);
                } else if (tableType == TableType.lab) {
                  return _buildDataRowForLab(value, currentIndex);
                } else if (tableType == TableType.viewPatient) {
                  return _buildDataRowForTestBarCode(value, currentIndex);
                } else if (tableType == TableType.inTransit) {
                  return _buildDataRowForTransit(value, currentIndex);
                } else if (tableType == TableType.process) {
                  return _buildDataRowForProcess(value, currentIndex);
                } else if (tableType == TableType.testStatus) {
                  return _buildDataRowForTestStatus(value, currentIndex);
                } else if (tableType == TableType.sample) {
                  return _buildDataRowForSampleManagement(value, currentIndex);
                } else {
                  throw Exception("*** Invalid type provided for ${value.toString()}");
                }
              }).toList(),
              showBottomBorder: true,
            )
          ],
        ),
      ],
    );
  }

  Widget _actionsRow(int currentIndex, dynamic value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      InkWell(
          onTap: () {
            onEditClick.call(currentIndex - 1);
          },
          child: Icon(Icons.note_alt_outlined)),
      InkWell(
          onTap: () {
            onViewClick!.call(value);
          },
          child: Icon(Icons.remove_red_eye_outlined))
    ]);
  }

  Widget _barCodeWidget({required String text, required String barCode}) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(text),
      Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: SvgPicture.string(
          BarcodeUtility.getBarcodeSvgString(barCode),
          width: 80,
          height: 40,
        ),
      )
    ]);
  }

  DataRow _buildDataRowForLab(Lab lab, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(Text(lab.labName)),
      DataCell(Text(lab.emailId)),
      DataCell(Text(lab.contactNumber)),
      DataCell(_actionsRow(currentIndex, currentIndex))
    ]);
  }

  DataRow _buildDataRowForTest(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.testName)),
      DataCell(Text(test.department)),
      DataCell(Text(test.sampleType)),
      DataCell(Text(test.turnAroundTime)),
      DataCell(Text(test.price.toString())),
      DataCell(_actionsRow(currentIndex, test))
    ]);
  }

  DataRow _buildDataRowForTestBarCode(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(_barCodeWidget(
        text: test.testName,
        barCode: "${test.id}",
      )),
      DataCell(Text(test.sampleType)),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.price.toString())),
      DataCell(Text(test.taxPercentage.toString())),
      DataCell(Text(test.totalPrice.toString())),
      // DataCell(Text(test.price.toString())),
    ]);
  }

  ///in tansit managment
  DataRow _buildDataRowForTransit(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(_barCodeWidget(
        text: test.testName,
        barCode: "${test.id}",
      )),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.testName)),
      DataCell(Text("Processing unit")),
      DataCell(
        commonBtn(
            text: "Approve Transit",
            isEnable: true,
            calll: () {
              onSubmit!.call(test);
            }),
      ),
      DataCell(commonBtn(
          text: "To Pdf",
          isEnable: true,
          calll: () {
            onPrintPdf!.call(test);
          }))
    ]);
  }

  ///Process managment
  DataRow _buildDataRowForProcess(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(_barCodeWidget(
        text: test.testName,
        barCode: "${test.id}",
      )),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.testName)),
      DataCell(Text("Processing unit")),
      DataCell(DropdownButtonFormField(
        icon: IconStore.downwardArrow,
        decoration: const InputDecoration(
          constraints: BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 45, maxHeight: 50),
          border: OutlineInputBorder(),
          hintText: "Select Status",
        ),
        items: const <DropdownMenuItem>[
          DropdownMenuItem(value: "processing", child: Text('Processing')),
          DropdownMenuItem(value: "completed", child: Text('Completed'))
        ],
        onChanged: (value) {
          int intValue;
          if (value == "processing") {
            intValue = 4;
          } else if (value == "completed") {
            intValue = 5;
          } else {
            intValue = 2;
          }
          onEditClick.call("$intValue");
        },
      )),
      DataCell(commonBtn(
          text: "Submit",
          isEnable: true,
          calll: () {
            onSubmit!.call(test);
          })),
      DataCell(commonBtn(
          text: "To Pdf",
          isEnable: true,
          calll: () {
            onPrintPdf!.call(test);
          }))
    ]);
  }

  ///test status
  DataRow _buildDataRowForTestStatus(Patient patient, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(Text("${patient.firstName} ${patient.middleName} ${patient.lastName}")),
      DataCell(Text(patient.umrNumber)),
      DataCell(Text("Test Name")),
      DataCell(Text("Test Code")),
      DataCell(Text("Sample Collection center")),
      DataCell(Text("Proc.. unit")),
      DataCell(Text("Status")),
      DataCell(commonBtn(text: "Report", isEnable: true, calll: () {}))
    ]);
  }

  ///Sample Management
  DataRow _buildDataRowForSampleManagement(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(_barCodeWidget(
        text: test.testName,
        barCode: "${test.id}",
      )),
      DataCell(DropdownButtonFormField(
        icon: IconStore.downwardArrow,
        decoration: const InputDecoration(
          constraints: BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 45, maxHeight: 50),
          border: OutlineInputBorder(),
          hintText: "Select Processing Unit",
        ),
        items: const <DropdownMenuItem>[
          DropdownMenuItem(value: "processing-unit", child: Text('Processing Unit')),
          DropdownMenuItem(value: "both", child: Text('Both'))
        ],
        onChanged: (value) {
          onEditClick.call(value);
        },
      )),
      DataCell(BlocBuilder<InTransitBloc, InTransitState>(
        builder: (context, state) {
          if (!state.invoiceMappings.isNull && state.invoiceMappings!.isNotEmpty) {
            var currentMapping = state.invoiceMappings!.firstWhere((element) => element.testId == test.id);
            if (!currentMapping.isNull) {
              return commonBtn(
                  text: "Collect Sample",
                  isEnable: currentMapping!.status == 5 ? false : true,
                  calll: () {
                    onSubmit!.call(test);
                  });
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      )),
      DataCell(commonBtn(
          text: "To Pdf",
          isEnable: true,
          calll: () {
            onPrintPdf!.call(test);
          }))
    ]);
  }

  DataRow _buildDataRowForPatient(Patient patient, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(Text(patient.umrNumber)),
      DataCell(Text("${patient.firstName} ${patient.middleName} ${patient.lastName}")),
      DataCell(Text(patient.consultedDoctor)),
      DataCell(Text(patient.insuraceNumber)),
      DataCell(Text(patient.mobileNumber.toString())),
      DataCell(Text(patient.emailId)),
      DataCell(_actionsRow(currentIndex, patient))
    ]);
  }
}
