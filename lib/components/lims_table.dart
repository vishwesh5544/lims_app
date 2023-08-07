import "package:flutter/material.dart";
import "package:lims_app/models/lab.dart";
import "package:lims_app/models/patient.dart";
import "package:lims_app/models/test.dart";

class LimsTable extends StatelessWidget {
  const LimsTable({required this.columnNames, required this.rowData, super.key});

  final List<String> columnNames;
  final List<dynamic> rowData;

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
              headingRowColor: MaterialStateProperty.all(Colors.black),
              headingTextStyle: const TextStyle(color: Colors.white),
              dataRowColor: MaterialStateProperty.all(Colors.grey.shade300),
              columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
              rows: rowData.map((value) {
                var currentIndex = rowData.indexOf(value) + 1;
                // TODO: bring value type check to top level
                if (value is Patient) {
                  return _buildDataRowForPatient(value, currentIndex);
                } else if (value is Test) {
                  return _buildDataRowForTest(value, currentIndex);
                } else if (value is Lab) {
                  return _buildDataRowForLab(value, currentIndex);
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

  DataRow _buildDataRowForLab(Lab lab, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(Text(lab.labName)),
      DataCell(Text(lab.emailId)),
      DataCell(Text(lab.contactNumber)),
      DataCell(_actionsRow())
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
      DataCell(_actionsRow())
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
      DataCell(_actionsRow())
    ]);
  }

  Widget _actionsRow() {
    return const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Icon(Icons.note_alt_outlined), Icon(Icons.remove_red_eye_outlined)]);
  }
}
