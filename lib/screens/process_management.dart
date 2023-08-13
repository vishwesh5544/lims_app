import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_bloc.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_event.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_state.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/components/lims_table.dart";
import "package:lims_app/models/test.dart";
import "package:lims_app/utils/pdf_utility.dart";
import "package:lims_app/utils/screen_helper.dart";
import "package:lims_app/utils/utils.dart";

import "../components/common_disabled_field.dart";
import "../components/common_header.dart";

class ProcessManagement extends StatefulWidget {
  const ProcessManagement({Key? key}) : super(key: key);

  @override
  State<ProcessManagement> createState() => _ProcessManagementState();
}

class _ProcessManagementState extends State<ProcessManagement> {
  TextEditingController textController =
      TextEditingController(text: "sudovish@gmail.com");
  late final InTransitBloc bloc;
  String status = "";
  static List<String> columnNames = [
    "#",
    "Name of the Test",
    "Test Code",
    "Sample type",
    "Process Unit",
    "Status",
    "Submit",
    ""
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonHeader(title: "Process Management"),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: commonSearchArea(
                              title: "UMR No./Patient Name",
                              hint: "Search by URM No./Patient Name",
                              textController: textController,
                              onSubmit: (value) {
                                bloc.add(SearchPatient(value));
                              })),

                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            CommonGreyFiled(
                                title: "UMR Number",
                                value: state.patient?.umrNumber ?? ""),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20)),
                            CommonGreyFiled(
                                title: "Patient Name",
                                value:
                                    "${state.patient?.firstName ?? ''} ${state.patient?.middleName ?? ''} ${state.patient?.lastName ?? ''}"),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: state.testsList?.isNotEmpty ?? false,
                        child: LimsTable(
                            columnNames: columnNames,
                            tableType: TableType.process,
                            tableRowHeight: 95,
                            onEditClick: (value) {
                              status = value;
                            },
                            onSubmit: (test) {
                              int invoiceId = state.invoiceMappings!
                                  .firstWhere(
                                      (element) => element.testId == test.id)
                                  .id!;

                              bloc.add(UpdateInTransit(
                                  invoiceId: invoiceId,
                                  userId: state.patient!.id!,
                                  status: int.parse(status)));

                              ScreenHelper.showAlertPopup(
                                  "Process status updated successfully",
                                  context);
                            },
                            onPrintPdf: (Test test) {
                              var testId = test.id;
                              var userId = state.patient?.id;
                              var invoiceId = state.invoiceMappings
                                  ?.firstWhere((invoice) =>
                                      invoice.testId == test.id &&
                                      invoice.patientId == state.patient!.id)
                                  .id;
                              var barcodeString =
                                  "{testId:, $testId, userId: $userId, invoiceId: $invoiceId}";
                              PdfUtility.savePdf(
                                  context, barcodeString.toString());
                            },
                            rowData: getTestList(state)),
                      )

                      // Container(
                      //   margin: EdgeInsets.symmetric(vertical: 10),
                      //   child: commonBtn(text: "Update", isEnable: true, calll: (){
                      //     showToast(msg: "Update");
                      //   }),
                      // )
                      // ,
                    ],
                  ),
                ),
              ));
        });
  }

  getTestList(InTransitState state) {
    return state.testsList!.where((test) {
      final invoiceMappings = state.invoiceMappings?.where(
          (invoice) => invoice.testId == test.id && invoice.status >= 3);
      if (invoiceMappings != null && invoiceMappings.isNotEmpty) {
        return true;
      }
      return false;
    }).toList();
  }
}
