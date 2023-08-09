import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_bloc.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_event.dart";
import "package:lims_app/bloc/in_transit_bloc/in_transit_state.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/bloc/test_bloc/test_state.dart";
import "package:lims_app/components/buttons/redirect_button.dart";
import "package:lims_app/components/lims_table.dart";
import "package:lims_app/components/search_header.dart";
import "package:lims_app/screens/add_test.dart";
import "package:lims_app/test_items/redirect_to_test_menu.dart";
import "package:lims_app/utils/strings/button_strings.dart";
import "package:lims_app/utils/strings/route_strings.dart";
import "package:lims_app/utils/strings/search_header_strings.dart";
import "package:lims_app/utils/utils.dart";

import "../utils/color_provider.dart";
import "../utils/strings/add_test_strings.dart";
import "../utils/text_utility.dart";

class ProcessManagement extends StatefulWidget {
  const ProcessManagement({Key? key}) : super(key: key);

  @override
  State<ProcessManagement> createState() => _ProcessManagementState();
}

class _ProcessManagementState extends State<ProcessManagement> {
  TextEditingController textController = TextEditingController(text: "vishweshshukla20@gmail.com");
  late final InTransitBloc bloc;
  String status = "";
  static List<String> columnNames = [
    "#",
    "Name of the Test",
    "Test Code",
    "Sample type",
    "Process Unit",
    "Status",
    "Submit"
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
        listener: (context, state) {

        },
        builder: (context, state) {
          return WillPopScope(
              onWillPop: () async {
                BlocProvider.of<TestBloc>(context).add(OnAddTest());
                return true;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(color: ColorProvider.blueDarkShade),
                        // margin: EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Process Management",
                                style: TextUtility.getBoldStyle(18.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: commonSearchArea(
                              title: "UMR No./Patient Name",
                              hint: "Search by URM No./Patient Name",
                              textController: textController, onSubmit: (value){
                            bloc.add(SearchPatient(value));

                            showToast(msg: value);
                          })
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("UMR NUMBER"),
                                SizedBox(height: 10),
                                TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 40, maxHeight: 45),
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.grey,
                                    hintText: state.patient?.umrNumber ?? "",
                                  ),
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Patient Name"),
                                SizedBox(height: 10),
                                TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 40, maxHeight: 45),
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.grey,
                                    hintText: "${state.patient?.firstName ?? ''} ${state.patient?.middleName ?? ''} ${state.patient?.lastName ?? ''}",
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      LimsTable(columnNames: columnNames,
                          tableType: TableType.process,
                          onEditClick: (value){
                        status = value;

                          },
                          onSubmit: (test){
                            int invoiceId = state.invoiceMappings!.firstWhere((element) => element.testId == test.id).id!;

                            bloc.add(UpdateInTransit(
                            invoiceId: invoiceId,
                            userId: state.patient!.id!,
                            status: int.parse(status)));
                          },
                          rowData: state.testsList!),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: commonBtn(text: "Update", isEnable: true, calll: (){
                          showToast(msg: "Update");
                        }),
                      )
                      ,
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

}
