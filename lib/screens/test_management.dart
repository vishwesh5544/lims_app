import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/bloc/test_bloc/test_state.dart";
import "package:lims_app/components/buttons/redirect_button.dart";
import "package:lims_app/components/lims_table.dart";
import "package:lims_app/components/search_header.dart";
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
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RedirectButton(buttonText: ButtonStrings.addTest, routeName: RouteStrings.addTest),
                  ],
                ),
                const SearchHeader(
                    headerTitle: SearchHeaderStrings.testsListTitle,
                    placeholder: SearchHeaderStrings.searchTestsPlaceholder),
                BlocBuilder<TestBloc, TestState>(
                  builder: (context, state) {
                    return LimsTable(columnNames: columnNames, rowData: state.testsList);
                  },
                ),
                redirectToTestMenu(),
              ].map((el) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: el)).toList(),
            ),
          ),
        ),
      ),
    ));
  }
}
