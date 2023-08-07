import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:lims_app/models/lab.dart";
import "package:lims_app/models/patient.dart";
import "package:lims_app/models/test.dart";
import "package:lims_app/utils/utils.dart";

import "../utils/barcode_utility.dart";

enum TableType { addPatient, addTest, viewPatient, lab }

class LimsTable extends StatelessWidget {
  LimsTable(
      {required this.columnNames,
      required this.rowData,
      required this.tableType,
        required this.onEditClick,
      super.key});

  final List<String> columnNames;
  final List<dynamic> rowData;
  TableType tableType;
  Function onEditClick;

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
              dataRowHeight: 80,
              headingRowColor: MaterialStateProperty.all(Colors.black),
              headingTextStyle: const TextStyle(color: Colors.white),
              dataRowColor: MaterialStateProperty.all(Colors.grey.shade300),
              columns: columnNames
                  .map((name) => DataColumn(label: Text(name)))
                  .toList(),
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
                } else {
                  throw Exception(
                      "*** Invalid type provided for ${value.toString()}");
                }
              }).toList(),
              showBottomBorder: true,
            )
          ],
        ),
      ],
    );
  }

  Widget _actionsRow(int currentIndex) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      InkWell(onTap: () {
        onEditClick.call(currentIndex);
      }, child: Icon(Icons.note_alt_outlined)),
      Icon(Icons.remove_red_eye_outlined)
    ]);
  }

  Widget _barCodeWidget({required String text, required String barCode}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text),
          SvgPicture.string(
            BarcodeUtility.getBarcodeSvgString(barCode),
            width: 100,
            height: 50,
          )
        ]);
  }

  DataRow _buildDataRowForLab(Lab lab, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(Text(lab.labName)),
      DataCell(Text(lab.emailId)),
      DataCell(Text(lab.contactNumber)),
      DataCell(_actionsRow(currentIndex))
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
      DataCell(_actionsRow(currentIndex))
    ]);
  }

  DataRow _buildDataRowForTestBarCode(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(_barCodeWidget(
        text: test.testName,
        barCode: "${test.id}",
      )),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.testName)),
      DataCell(Text(test.department)),
      DataCell(Text(test.sampleType)),
      DataCell(Text(test.turnAroundTime)),
      DataCell(Text(test.price.toString())),
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
      DataCell(_actionsRow(currentIndex))
    ]);
  }
}
