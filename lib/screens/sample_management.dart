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
import "package:lims_app/utils/update_status.dart";
import "package:lims_app/utils/utils.dart";

import "../components/common_disabled_field.dart";
import "../components/common_header.dart";

class SampleManagement extends StatefulWidget {
  const SampleManagement({Key? key}) : super(key: key);

  @override
  State<SampleManagement> createState() => _SampleManagementState();
}

class _SampleManagementState extends State<SampleManagement> {
  TextEditingController textController = TextEditingController();
  late final InTransitBloc bloc;
  static List<String> columnNames = [
    "#",
    "Name of the Test",
    "Process Unit",
    "Actions"
  ];

  String processingUnit = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<TestBloc>(context).add(FetchAllTests());
      bloc = context.read<InTransitBloc>();
      bloc.add(ResetState());
      bloc.add(CacheAllPatient());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InTransitBloc, InTransitState>(
        listener: (context, state) {
      if (state.updateStatus is Updated) {}
    }, builder: (context, state) {
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
                  CommonHeader(title: "Add New Sample"),
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.95,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 25),
                            child: commonSearchArea(
                              title: "UMR No./Patient Name",
                              hint: "Search by URM No./Patient Name",
                              textController: textController,
                              onSubmit: (String value) {
                                bloc.add(SearchPatient(value));
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CommonGreyFiled(
                                    width: 275,
                                    title: "UMR Number",
                                    value: state.patient?.umrNumber ?? ""),
                                const SizedBox(width: 25),
                                CommonGreyFiled(
                                    width: 275,
                                    title: "Patient Name",
                                    value:
                                        "${state.patient?.firstName ?? ''} ${state.patient?.middleName ?? ''} ${state.patient?.lastName ?? ''}"),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: state.testsList?.isNotEmpty ?? false,
                            child: LimsTable(
                                color: Colors.white,
                                tableRowHeight: 155,
                                tableBorder: TableBorder(
                                  horizontalInside: getBorder(),
                                  right: getBorder(),
                                  left: getBorder(),
                                ),
                                columnNames: columnNames,
                                tableType: TableType.sample,
                                onEditClick: (value) {
                                  showToast(msg: value);
                                  processingUnit = value;
                                },
                                onSubmit: (test) {
                                  if (processingUnit.isNotEmpty) {
                                    int invoiceId = state.invoiceMappings!
                                        .firstWhere((element) =>
                                            element.testId == test.id)
                                        .id!;

                                    BlocProvider.of<InTransitBloc>(context).add(
                                        UpdateInTransit(
                                            invoiceId: invoiceId,
                                            userId: state.patient!.id!,
                                            processingUnit: processingUnit,
                                            status: 2));
                                    ScreenHelper.showAlertPopup(
                                        "Sample status updated successfully",
                                        context);
                                  } else {
                                    ScreenHelper.showAlertPopup(
                                        "Please select Processing Unit first!",
                                        context);
                                  }
                                },
                                onPrintPdf: (Test test) {
                                  var ptid = state.invoiceMappings
                                      ?.firstWhere((invoice) =>
                                          invoice.testId == test.id &&
                                          invoice.patientId ==
                                              state.patient!.id)
                                      .ptid;

                                  PdfUtility.savePdf(context, ptid.toString());
                                },
                                rowData: getTestList(state)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }

  getTestList(InTransitState state) {
    return state.testsList!.where((test) {
      final invoiceMappings = state.invoiceMappings?.where(
          (invoice) => invoice.testId == test.id && invoice.status >= 1);
      if (invoiceMappings != null && invoiceMappings.isNotEmpty) {
        return true;
      }
      return false;
    }).toList();
  }
}
