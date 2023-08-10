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
import "package:lims_app/utils/utils.dart";

import "../utils/barcode_utility.dart";
import "../utils/icons/icon_store.dart";

enum TableType { addPatient, addTest, viewPatient, lab, inTransit, process, testStatus, sample }

class LimsTable extends StatefulWidget {
  LimsTable(
      {required this.columnNames,
      required this.rowData,
      required this.tableType,
      required this.onEditClick,
      this.conditionalButton,
      this.onViewClick,
      this.onSubmit,
      this.onPrintPdf,
      this.onSelected,
        this.tableRowHeight,
      super.key});

  final List<String> columnNames;
  final List<dynamic> rowData;
  TableType tableType;
  Function onEditClick;
  Function? onViewClick;
  Function? onSubmit;
  Function? onPrintPdf;
  Function? onSelected;
  Widget? conditionalButton;
  double? tableRowHeight;

  @override
  State<LimsTable> createState() => _LimsTableState();
}

class _LimsTableState extends State<LimsTable> {
  late final inTransitBloc;

  @override
  void initState() {
    inTransitBloc = context.read<InTransitBloc>();
    inTransitBloc.add(FetchFilteredLabs());
    inTransitBloc.add(FetchAllInvoiceMapping());

    super.initState();
  }

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
              dataRowHeight: widget.tableRowHeight,
              dividerThickness: 0.2,
              headingRowHeight: 50,
              headingRowColor: MaterialStateProperty.all(Colors.black),
              headingTextStyle: const TextStyle(color: Colors.white),
              dataRowColor: MaterialStateProperty.all(Colors.white),
              border: TableBorder(horizontalInside: getBorder(), verticalInside: getBorder(), right: getBorder(), left: getBorder()),
              columns: widget.columnNames.map((name) => DataColumn(label: Text(name, maxLines: 2,))).toList(),
              rows: widget.rowData.map((value) {
                var currentIndex = widget.rowData.indexOf(value) + 1;
                // TODO: bring value type check to top level
                if (widget.tableType == TableType.addPatient) {
                  return _buildDataRowForPatient(value, currentIndex);
                } else if (widget.tableType == TableType.addTest) {
                  return _buildDataRowForTest(value, currentIndex);
                } else if (widget.tableType == TableType.lab) {
                  return _buildDataRowForLab(value, currentIndex);
                } else if (widget.tableType == TableType.viewPatient) {
                  return _buildDataRowForTestBarCode(value, currentIndex);
                } else if (widget.tableType == TableType.inTransit) {
                  return _buildDataRowForTransit(value, currentIndex);
                } else if (widget.tableType == TableType.process) {
                  return _buildDataRowForProcess(value, currentIndex);
                } else if (widget.tableType == TableType.testStatus) {
                  return _buildDataRowForTestStatus(value, currentIndex);
                } else if (widget.tableType == TableType.sample) {
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
            widget.onEditClick.call(currentIndex - 1);
          },
          child: Icon(Icons.note_alt_outlined)),
      InkWell(
          onTap: () {
            widget.onViewClick!.call(value);
          },
          child: Icon(Icons.remove_red_eye_outlined))
    ]);
  }

  Widget _barCodeWidget({required String text, required String barCode}) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(text, style: TextStyle(fontSize: 10)),
      Container(
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.all(3),
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
      DataCell(BlocConsumer<InTransitBloc, InTransitState>(
        listener: (context, state) {},
        builder: (context, state) {
          if(state.invoiceMappings!=null && state.invoiceMappings!.isNotEmpty) {
            var ptid = state.invoiceMappings?.firstWhere((element) => element.testId == test.id).ptid;
            return _barCodeWidget(
              text: test.testName,
              barCode: "${ptid}",
            );
          } else {
            return Container();
          }
        },
      )),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.testName)),
      DataCell(BlocConsumer<InTransitBloc, InTransitState>(
        listener: (context, state) {},
        builder: (context, state) {
          var mappings = state.invoiceMappings;

          if (mappings!=null && mappings.isNotEmpty) {
            var name = mappings.firstWhere((element) => element.testId == test.id).processingUnit;

            return Text(name ?? "");
          } else {
            return Container();
          }
        },
      )),
      DataCell(
        commonBtn(
            text: "Approve Transit",
            isEnable: true,
            width: 120,
            calll: () {
              widget.onSubmit!.call(test);
            }),
      ),
      DataCell(commonBtn(
          text: "To Pdf",
          isEnable: true,
          width: 120,
          calll: () {
            widget.onPrintPdf!.call(test);
          }))
    ]);
  }

  ///Process managment
  DataRow _buildDataRowForProcess(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(BlocConsumer<InTransitBloc, InTransitState>(
        listener: (context, state) {},
        builder: (context, state) {
          if(state.invoiceMappings!=null && state.invoiceMappings!.isNotEmpty) {
            var ptid = state.invoiceMappings?.firstWhere((element) => element.testId == test.id).ptid;
            return _barCodeWidget(
              text: test.testName,
              barCode: "${ptid}",
            );
          } else {
            return Container();
          }
        },
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
          widget.onEditClick.call("$intValue");
        },
      )),
      DataCell(commonBtn(
          text: "Submit",
          isEnable: true,
          calll: () {
            widget.onSubmit!.call(test);
          })),
      DataCell(commonBtn(
          text: "To Pdf",
          isEnable: true,
          calll: () {
            widget.onPrintPdf!.call(test);
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
      DataCell(BlocConsumer<InTransitBloc, InTransitState>(
        listener: (context, state) {},
        builder: (context, state) {
          if(state.invoiceMappings!=null && state.invoiceMappings!.isNotEmpty) {
            var ptid = state.invoiceMappings?.firstWhere((element) => element.testId == test.id).ptid;
            return _barCodeWidget(
              text: test.testName,
              barCode: "${ptid}",
            );
          } else {
            return Container();
          }
        },
      )),
      DataCell(BlocConsumer<InTransitBloc, InTransitState>(
        listener: (context, state) {},
        builder: (context, state) {
          return DropdownButtonFormField(
              items: state.filteredLabs?.map((Lab lab) {
                return DropdownMenuItem(
                  value: lab.labName,
                  child: Text(lab.labName),
                );
              }).toList(),
              onChanged: (value) {
                widget.onEditClick(value);
              });
        },
      )),
      DataCell(BlocBuilder<InTransitBloc, InTransitState>(
        builder: (context, state) {
          if (state.invoiceMappings !=null && state.invoiceMappings!.isNotEmpty) {
            var currentMapping = state.invoiceMappings!.firstWhere((element) => element.testId == test.id);
            return commonBtn(
                text: "Collect Sample",
                isEnable: currentMapping.status == 5 ? false : true,
                calll: () {
                  widget.onSubmit!.call(test);
                });
                    } else {
            return Container();
          }
        },
      )),
      DataCell(commonBtn(
          text: "To Pdf",
          isEnable: true,
          calll: () {
            widget.onPrintPdf!.call(test);
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
