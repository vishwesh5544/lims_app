import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/bloc/test_bloc/test_state.dart";
import "package:lims_app/components/buttons/redirect_button.dart";
import "package:lims_app/components/lims_table.dart";
import "package:lims_app/components/search_header.dart";
import "package:lims_app/screens/add_test.dart";
import "package:lims_app/utils/strings/button_strings.dart";
import "package:lims_app/utils/strings/route_strings.dart";
import "package:lims_app/utils/strings/search_header_strings.dart";

import "../utils/color_provider.dart";
import "../utils/text_utility.dart";

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
        listener: (context, state) {},
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              BlocProvider.of<TestBloc>(context).add(OnAddTest());
              return true;
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: state.isAddTest ? const AddTest() : testWidget(state)),
          );
        });
  }

  testWidget(TestState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RedirectButton(
                  buttonText: ButtonStrings.addTest,
                  routeName: RouteStrings.addTest,
                  onClick: () {
                    BlocProvider.of<TestBloc>(context)
                        .add(OnAddTest(value: true));
                  }),
            ],
          ),
          SearchHeader(
              headerTitle: SearchHeaderStrings.testsListTitle,
              placeholder: SearchHeaderStrings.searchTestsPlaceholder,
              onClickSearch: (text) {
                BlocProvider.of<TestBloc>(context).add(OnSearch(value: text));
              }),
          LimsTable(
            columnNames: columnNames,
            tableType: TableType.addTest,
            onEditClick: (value) {
              BlocProvider.of<TestBloc>(context)
                  .add(OnAddTest(value: true, currentSelectedPriview: value));
            },
            onViewClick: (value) {
              _showPreviewDialog(value);
            },
            rowData: state.searchTestsList,
          ),
        ]
            .map((el) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10), child: el))
            .toList(),
      ),
    );
  }

  /// invoice dialog
  Future<void> _showPreviewDialog(value) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            insetPadding: EdgeInsets.zero,
            titleTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            titlePadding: EdgeInsets.zero,
            title: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: ColorProvider.blueDarkShade),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(),
                  const Text('Test Details'),
                  InkWell(
                    child:
                        const Icon(Icons.cancel_rounded, color: Colors.white),
                    onTap: () => Navigator.pop(context, "Cancel"),
                  )
                ],
              ),
            ),
            content: Container(
              // height: 600,
              width: 600,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getRow(title: "Test Code", data: value.testCode),
                    getRow(title: "Test Name", data: value.testName),
                    getRow(title: "Department", data: value.department),
                    getRow(title: "Indication", data: value.indications),
                    getRow(title: "Temperature", data: value.temperature),
                    getRow(title: "Sample Type", data: value.sampleType),
                    getRow(title: "Vacutiner", data: value.vacutainer),
                    getRow(title: "Volume", data: value.volume),
                    getRow(title: "Method", data: value.method),
                    getRow(title: "Price", data: "${value.price}"),
                    getRow(title: "TAT", data: value.turnAroundTime),
                  ],
                ),
              ),
            ));
      },
    );
  }

  getRow({String title = "Invoice Receipt", String data = ""}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            color: ColorProvider.blueDarkShade,
            width: 250,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            child: Text(title,
                style: TextUtility.getStyle(18, color: Colors.white))),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            child: Text(data,
                style: TextUtility.getStyle(18, color: Colors.black)))
      ],
    );
  }
}
