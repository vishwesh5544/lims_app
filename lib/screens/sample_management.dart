import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
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

class SampleManagement extends StatefulWidget {
  const SampleManagement({Key? key}) : super(key: key);

  @override
  State<SampleManagement> createState() => _SampleManagementState();
}

class _SampleManagementState extends State<SampleManagement> {
  TextEditingController textController = TextEditingController();
  static List<String> columnNames = [
    "#",
    "Name of the Test",
    "Process Unit",
    "Actions"
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<TestBloc>(context).add(FetchAllTests());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestBloc, TestState>(
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
                        // margin: EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("In Transit Management",
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
                            showToast(msg: value);
                          })
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: const Row(
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
                                    hintText: "fhasdjfgaksjhdfghks",
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
                                    hintText: "Parth Pitroda",
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      LimsTable(columnNames: columnNames,
                          tableType: TableType.sample,
                          onEditClick: (value){

                          },
                          rowData: state.searchTestsList),

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
