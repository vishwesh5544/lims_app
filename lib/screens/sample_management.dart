import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_bloc.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_event.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_state.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/bloc/test_bloc/test_state.dart";
import "package:lims_app/components/buttons/redirect_button.dart";
import "package:lims_app/components/lims_table.dart";
import "package:lims_app/components/search_header.dart";
import "package:lims_app/models/in_transit.dart";
import "package:lims_app/models/invoice_mapping.dart";
import "package:lims_app/models/test.dart";
import "package:lims_app/screens/add_test.dart";
import "package:lims_app/test_items/redirect_to_test_menu.dart";
import "package:lims_app/utils/barcode_utility.dart";
import "package:lims_app/utils/pdf_utility.dart";
import "package:lims_app/utils/screen_helper.dart";
import "package:lims_app/utils/strings/button_strings.dart";
import "package:lims_app/utils/strings/route_strings.dart";
import "package:lims_app/utils/strings/search_header_strings.dart";
import "package:lims_app/utils/update_status.dart";
import "package:lims_app/utils/utils.dart";

import "../components/common_disabled_field.dart";
import "../components/common_header.dart";
import "../utils/color_provider.dart";
import "../utils/strings/add_test_strings.dart";
import "../utils/text_utility.dart";

class SampleManagement extends StatefulWidget {
  const SampleManagement({Key? key}) : super(key: key);

  @override
  State<SampleManagement> createState() => _SampleManagementState();
}

class _SampleManagementState extends State<SampleManagement> {
  TextEditingController textController = TextEditingController(text: "vs23@gmail.com");
  late final InTransitBloc bloc;
  static List<String> columnNames = ["#", "Name of the Test", "Process Unit", "Actions", ""];

  String processingUnit = "";

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
    return BlocConsumer<InTransitBloc, InTransitState>(listener: (context, state) {
      if (state.updateStatus is Updated) {

      }
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
                 CommonHeader(title:  "Sample Management"),
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
                    margin: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        CommonGreyFiled(title: "UMR Number", value: state.patient?.umrNumber ?? ""),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                        CommonGreyFiled(title: "Patient Name", value: "${state.patient?.firstName ?? ''} ${state.patient?.middleName ?? ''} ${state.patient?.lastName ?? ''}"),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: state.testsList?.isNotEmpty??false,
                    child:  LimsTable(
                      tableRowHeight: 95,
                      columnNames: columnNames,
                      tableType: TableType.sample,
                      onEditClick: (value) {
                        showToast(msg: value);
                        processingUnit = value;
                      },
                      onSubmit: (test) {
                        if (processingUnit.isNotEmpty) {
                          int invoiceId = state.invoiceMappings!.firstWhere((element) => element.testId == test.id).id!;

                          BlocProvider.of<InTransitBloc>(context).add(UpdateInTransit(
                              invoiceId: invoiceId,
                              userId: state.patient!.id!,
                              processingUnit: processingUnit,
                              status: 2));
                          ScreenHelper.showAlertPopup("Sample status updated successfully", context);
                        } else {
                          ScreenHelper.showAlertPopup("Please select Processing Unit first!", context);
                        }
                      },
                      onPrintPdf: (Test test) {
                        var testId = test.id;
                        var userId = state.patient?.id;
                        var invoiceId = state.invoiceMappings
                            ?.firstWhere(
                                (invoice) => invoice.testId == test.id && invoice.patientId == state.patient!.id)
                            .id;
                        var barcodeString = "testId:, $testId, userId: $userId, invoiceId: $invoiceId";
                        PdfUtility.savePdf(context, barcodeString.toString());
                      },
                      rowData: state.testsList!),
                  )
                ],
              ),
            ),
          ));
    });
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
}
