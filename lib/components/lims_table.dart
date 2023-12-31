import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_bloc.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_event.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_state.dart";
import "package:lims_app/bloc/patient_bloc/patient_bloc.dart";
import "package:lims_app/bloc/patient_bloc/patient_state.dart";
import "package:lims_app/models/lab.dart";
import "package:lims_app/models/patient.dart";
import "package:lims_app/models/test.dart";
import "package:lims_app/utils/color_provider.dart";
import "package:lims_app/utils/utils.dart";

import "../utils/icons/icon_store.dart";
import "barcode_widegt.dart";

enum TableType {
  addPatient,
  addTest,
  viewPatient,
  lab,
  inTransit,
  process,
  testStatus,
  sample
}

class LimsTable extends StatefulWidget {
  LimsTable(
      {required this.columnNames,
      required this.rowData,
      required this.tableType,
      required this.onEditClick,
      this.flex,
      this.conditionalButton,
      this.onViewClick,
      this.onSubmit,
      this.onPrintPdf,
      this.onSelected,
      this.tableRowHeight,
      this.tableBorder,
      this.color,
      super.key})
      : assert(flex == null || columnNames.length == flex.length);

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
  final Color? color;
  final TableBorder? tableBorder;
  final List<int>? flex;

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

  Future<bool> showAlertDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    if (result == null) return false;
    return result;
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
              dataRowMinHeight: widget.tableRowHeight,
              dataRowMaxHeight: widget.tableRowHeight,
              dividerThickness: 0.2,
              headingRowHeight: 50,
              headingRowColor: MaterialStateProperty.all(Colors.black),
              headingTextStyle: const TextStyle(color: Colors.white),
              dataRowColor: MaterialStateProperty.all(
                  widget.color ?? ColorProvider.lightGreyColor),
              columnSpacing: 0,
              border: widget.tableBorder ??
                  TableBorder(
                    horizontalInside: getBorder(),
                    right: getBorder(),
                    left: getBorder(),
                  ),
              columns: widget.columnNames
                  .map(
                    (name) => DataColumn(
                      label: Text(
                        name,
                        maxLines: 2,
                      ),
                    ),
                  )
                  .toList(),
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

  Widget _actionsRow(int currentIndex, dynamic value) {
    return Row(children: [
      InkWell(
          onTap: () {
            widget.onEditClick.call(currentIndex - 1);
          },
          child: const Icon(Icons.note_alt_outlined)),
      const SizedBox(width: 20),
      InkWell(
          onTap: () {
            widget.onViewClick!.call(value);
          },
          child: const Icon(Icons.remove_red_eye_outlined))
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
      DataCell(Text(test.totalPrice.toString())),
      DataCell(_actionsRow(currentIndex, test))
    ]);
  }

  DataRow _buildDataRowForTestBarCode(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(BlocConsumer<PatientBloc, PatientState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.createdPatientInvoices.isNotEmpty) {
            var ptid = state.createdPatientInvoices
                .firstWhere((element) => element.testId == test.id)
                .ptid;
            return barCodeWidget(
              text: test.testName,
              barCode: "$ptid",
            );
          } else {
            return const Text('Loading...');
          }
        },
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
      DataCell(Align(
        alignment: const FractionalOffset(0, 0.15),
        child: Text(currentIndex.toString()),
      )),
      DataCell(BlocConsumer<InTransitBloc, InTransitState>(
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
      )),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.testName)),
      DataCell(BlocConsumer<InTransitBloc, InTransitState>(
        listener: (context, state) {},
        builder: (context, state) {
          var mappings = state.invoiceMappings;

          if (mappings != null && mappings.isNotEmpty) {
            var name = mappings
                .firstWhere((element) => element.testId == test.id)
                .processingUnit;

            return Text(name ?? "");
          } else {
            return Container();
          }
        },
      )),
      DataCell(Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocConsumer<InTransitBloc, InTransitState>(
            listener: (context, state) {},
            builder: (context, state) {
              var mappings = state.invoiceMappings;

              if (mappings != null && mappings.isNotEmpty) {
                var status = mappings
                    .firstWhere((element) => element.testId == test.id)
                    .status;

                return commonBtn(
                  text: "Approve Transit",
                  isEnable: status == 2,
                  width: 120,
                  calll: () async {
                    final result = await showAlertDialog(
                      context,
                      "Approve Transit",
                      "Are you sure you want to approve this transit?",
                    );
                    if (result) {
                      widget.onSubmit!.call(test);
                    }
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          const SizedBox(height: 20),
          commonBtn(
              text: "Print",
              isEnable: true,
              width: 120,
              calll: () {
                widget.onPrintPdf!.call(test);
              })
        ],
      )),
    ]);
  }

  ///Process managment
  DataRow _buildDataRowForProcess(Test test, int currentIndex) {
    final width = MediaQuery.sizeOf(context).width;
    var totalFlex = widget.flex?.fold(0, (a, b) => a + b) ?? 1;
    totalFlex = totalFlex * 2;
    return DataRow(cells: [
      DataCell(SizedBox(
        width: widget.flex == null ? null : widget.flex![0] * width / totalFlex,
        child: Align(
          alignment: const FractionalOffset(0, 0.15),
          child: Text(currentIndex.toString()),
        ),
      )),
      DataCell(SizedBox(
        width: widget.flex == null ? null : widget.flex![1] * width / totalFlex,
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
      )),
      DataCell(
        SizedBox(
          width:
              widget.flex == null ? null : widget.flex![2] * width / totalFlex,
          child: Text(test.testCode),
        ),
      ),
      DataCell(
        SizedBox(
          width:
              widget.flex == null ? null : widget.flex![3] * width / totalFlex,
          child: Text(test.testName),
        ),
      ),
      DataCell(SizedBox(
        width: widget.flex == null ? null : widget.flex![4] * width / totalFlex,
        child: BlocConsumer<InTransitBloc, InTransitState>(
          listener: (context, state) {},
          builder: (context, state) {
            var mappings = state.invoiceMappings;

            if (mappings != null && mappings.isNotEmpty) {
              var name = mappings
                  .firstWhere((element) => element.testId == test.id)
                  .processingUnit;

              return Text(name ?? "");
            } else {
              return Container();
            }
          },
        ),
      )),
      DataCell(SizedBox(
        width: widget.flex == null ? null : widget.flex![5] * width / totalFlex,
        child: BlocConsumer<InTransitBloc, InTransitState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.invoiceMappings != null &&
                  state.invoiceMappings!.isNotEmpty) {
                var status = state.invoiceMappings
                    ?.firstWhere((element) => element.testId == test.id)
                    .status;
                String? initialValue;
                if (status != null) {
                  if (status == 4) {
                    initialValue = "processing";
                  } else if (status == 5) {
                    initialValue = "completed";
                  }
                }

                return FormBuilderDropdown(
                  name: 'status',
                  icon: IconStore.downwardArrow,
                  decoration: const InputDecoration(
                    constraints: BoxConstraints(
                        maxWidth: 250,
                        minWidth: 150,
                        minHeight: 45,
                        maxHeight: 50),
                    border: OutlineInputBorder(),
                    hintText: "Select Status",
                  ),
                  initialValue: initialValue,
                  items: <DropdownMenuItem>[
                    const DropdownMenuItem(
                        value: "processing", child: Text('Processing')),
                    if (status != null && status > 3)
                      const DropdownMenuItem(
                          value: "completed", child: Text('Completed'))
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
                );
              } else {
                return Container();
              }
            }),
      )),
      DataCell(SizedBox(
        width: widget.flex == null ? null : widget.flex![6] * width / totalFlex,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocConsumer<InTransitBloc, InTransitState>(
              listener: (context, state) {},
              builder: (context, state) {
                var mappings = state.invoiceMappings;

                if (mappings != null && mappings.isNotEmpty) {
                  var status = mappings
                      .firstWhere((element) => element.testId == test.id)
                      .status;

                  return commonBtn(
                    text: "Submit",
                    isEnable: status == 3 || status == 4,
                    calll: () async {
                      final result = await showAlertDialog(
                        context,
                        status == 3 ? "Process Sample" : "Submit Sample",
                        "Are you sure you want to ${status == 3 ? "process" : "submit"} this sample?",
                      );
                      if (result) {
                        widget.onSubmit!.call(test);
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
            const SizedBox(height: 20),
            commonBtn(
                text: "Print",
                isEnable: true,
                calll: () {
                  widget.onPrintPdf!.call(test);
                }),
          ],
        ),
      )),
    ]);
  }

  ///test status
  DataRow _buildDataRowForTestStatus(Patient patient, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(Text(
          "${patient.firstName} ${patient.middleName} ${patient.lastName}")),
      DataCell(Text(patient.umrNumber)),
      const DataCell(Text("Test Name")),
      const DataCell(Text("Test Code")),
      const DataCell(Text("Sample Collection center")),
      const DataCell(Text("Proc.. unit")),
      const DataCell(Text("Status")),
      DataCell(commonBtn(text: "Report", isEnable: true, calll: () {}))
    ]);
  }

  ///Sample Management
  DataRow _buildDataRowForSampleManagement(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(
        Align(
          alignment: const FractionalOffset(0, 0.15),
          child: Text(
            currentIndex.toString(),
          ),
        ),
      ),
      DataCell(BlocConsumer<InTransitBloc, InTransitState>(
        listener: (context, state) {
          // state.invoiceMappings?.firstWhere((element) => element.testId == test.id).status;
        },
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
      )),
      DataCell(BlocConsumer<InTransitBloc, InTransitState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.filteredLabs == null) {
            return Container();
          }
          return SizedBox(
            width: 400,
            child: FormBuilderDropdown<String>(
              name: 'processingUnit',
              decoration: const InputDecoration(
                labelText: 'Select Processing Unit',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              items: state.filteredLabs!.map((Lab lab) {
                return DropdownMenuItem<String>(
                  value: lab.labName,
                  child: Text(lab.labName),
                );
              }).toList(),
              onChanged: (value) {
                widget.onEditClick(value);
              },
            ),
          );
        },
      )),
      DataCell(BlocBuilder<InTransitBloc, InTransitState>(
        builder: (context, state) {
          if (state.invoiceMappings != null &&
              state.invoiceMappings!.isNotEmpty) {
            var currentMapping = state.invoiceMappings!
                .firstWhere((element) => element.testId == test.id);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                commonBtn(
                  text: currentMapping.status > 1
                      ? "Sample Collected"
                      : "Collect Sample",
                  isEnable: currentMapping.status == 1,
                  calll: () async {
                    final result = await showAlertDialog(
                      context,
                      "Collect Sample",
                      "Are you sure you want to collect sample for ${test.testName}?",
                    );
                    if (result) {
                      widget.onSubmit!.call(test);
                    }
                  },
                ),
                const SizedBox(height: 20),
                commonBtn(
                  text: "Print",
                  isEnable: currentMapping.status > 1,
                  calll: () {
                    widget.onPrintPdf!.call(test);
                  },
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      )),
    ]);
  }

  DataRow _buildDataRowForPatient(Patient patient, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(Tooltip(
        message: 'Tap to copy UMR Number',
        child: GestureDetector(
          onTap: () =>
              Clipboard.setData(ClipboardData(text: patient.umrNumber)),
          child: Text(patient.umrNumber),
        ),
      )),
      DataCell(Text(
          "${patient.firstName} ${patient.middleName} ${patient.lastName}")),
      DataCell(Text(patient.consultedDoctor)),
      DataCell(Text(patient.insuraceNumber)),
      DataCell(Text(patient.mobileNumber.toString())),
      DataCell(Text(patient.emailId)),
      DataCell(_actionsRow(currentIndex, patient))
    ]);
  }
}
