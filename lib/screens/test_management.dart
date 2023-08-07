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

class TestManagement extends StatefulWidget {
  const TestManagement({Key? key}) : super(key: key);

  @override
  State<TestManagement> createState() => _TestManagementState();
}

class _TestManagementState extends State<TestManagement> {
  static List<String> columnNames = [
    "#",
    "Test code",
    "Test name",
    "Department",
    "Sample type",
    "Turn Around Time (TAT)",
    "Price",
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: state.isAddTest? const AddTest(): testWidget(state)
          ),
        );
      }
    );
  }

  testWidget(TestState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RedirectButton(buttonText: ButtonStrings.addTest, routeName: RouteStrings.addTest, onClick: (){
                BlocProvider.of<TestBloc>(context).add(OnAddTest(value: true));
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => AddTest()));
              }),
            ],
          ),
          SearchHeader(
              headerTitle: SearchHeaderStrings.testsListTitle,
              placeholder: SearchHeaderStrings.searchTestsPlaceholder,
              onClickSearch: (text){
                BlocProvider.of<TestBloc>(context).add(OnSearch(value: text));
              }),
          LimsTable(columnNames: columnNames, rowData: state.searchTestsList),
        ].map((el) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: el)).toList(),
      ),
    );
  }
}
