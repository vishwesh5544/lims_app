import "package:age_calculator/age_calculator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
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

import "../bloc/patient_bloc/patient_event.dart";
import "../utils/color_provider.dart";
import "../utils/strings/add_test_strings.dart";
import "../utils/text_utility.dart";

class TestStatus extends StatefulWidget {
  const TestStatus({Key? key}) : super(key: key);

  @override
  State<TestStatus> createState() => _TestStatusState();
}

class _TestStatusState extends State<TestStatus> {
  TextEditingController textController = TextEditingController();

  TextEditingController _fromDatePickerTextController = TextEditingController();
  TextEditingController _toDatePickerTextController = TextEditingController();
  static List<String> columnNames = [
    "#",
    "Patient Name",
    "UMR Number"
    "Test Name",
    "Test Code",
    "Sample Collection Code",
    "Process Unit",
    "Status",
    ""
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ///search
                            commonSearchArea(
                                title: "Search Status",
                                hint: "Search by Patient Name/UMR/ Test/ Processing Unit/ Sample Collection Centre",
                                textController: textController, onSubmit: (value){
                              showToast(msg: value);
                            }),
                            ///from date
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: datePicker(
                                  onClick: (){
                                    _selectDate();
                              },datePickerTextController: _fromDatePickerTextController),
                            ),

                            ///to date
                            datePicker(datePickerTextController: _toDatePickerTextController, title: "To Date",
                            onClick: (){
                              _selectDate();
                            }),

                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: commonBtn(text: "Search", isEnable: true, calll: (){

                          }),
                        ),
                          ],
                        ),
                      ),

                      LimsTable(columnNames: columnNames,
                          tableType: TableType.inTransit,
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


  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(1995), lastDate: DateTime.now());
    if (pickedDate != null) {
      _fromDatePickerTextController.text = DateFormat(dateFormat).format(pickedDate);
      String dateText = _fromDatePickerTextController.text;
      // bloc.add(DobUpdated(dateText));
      var age = AgeCalculator.age(pickedDate).years;
      // bloc.add(AgeUpdated(age.toString()));
    }
  }
}
