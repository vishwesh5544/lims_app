import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/patient_bloc/patient_bloc.dart";
import "package:lims_app/bloc/patient_bloc/patient_event.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/bloc/test_bloc/test_state.dart";
import "package:lims_app/utils/strings/add_patient_strings.dart";
import "package:lims_app/models/test.dart";
import "package:lims_app/utils/icons/icon_store.dart";

class TestDetails extends StatefulWidget {
  const TestDetails({Key? key}) : super(key: key);

  @override
  State<TestDetails> createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  final BoxConstraints _commonBoxConstraint =
      const BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 45, maxHeight: 50);
  late final TestBloc testBloc;
  late final PatientBloc patientBloc;
  List<Test> selectedTests = [];
  int totalPrice = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      patientBloc = context.read<PatientBloc>();
      BlocProvider.of<TestBloc>(context).add(FetchAllTests());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _testDetailsForm();
  }

  Widget _testDetailsForm() {
    return Form(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _selectTestDropdown(),
        SingleChildScrollView(child: _selectedTestsTable()),
        Row(
          children: [Text("Total Price: \$${totalPrice.toString()}")],
        )
      ]
          .map((el) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: el,
              ))
          .toList(),
    ));
  }

  /// dropdown
  Widget _selectTestDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Test'),
        const SizedBox(height: 10),
        BlocBuilder<TestBloc, TestState>(
          builder: (context, state) {
            return DropdownButtonFormField(
              icon: IconStore.downwardArrow,
              decoration: const InputDecoration(
                constraints: BoxConstraints(maxWidth: 500, minWidth: 400, minHeight: 60, maxHeight: 70),
                border: OutlineInputBorder(),
                hintText: AddPatientStrings.selectTest,
              ),
              items: state.testsList.map((test) {
                return DropdownMenuItem(value: test, child: Text(test.testName));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTests.add(value!);
                  patientBloc.add(SelectedTestsUpdated(selectedTests));
                  for (var test in selectedTests) {
                    totalPrice += test.price;
                  }
                });
              },
            );
          },
        )
      ],
    );
  }

  /// tests table
  Widget _selectedTestsTable() {
    List<String> columnNames = [
      "#",
      "Test code",
      "Test name",
      "Department",
      "Sample type",
      "Turn Around Time (TAT)",
      "Price",
      "Actions"
    ];

    return Column(
      children: [
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.black),
              headingTextStyle: const TextStyle(color: Colors.white),
              dataRowColor: MaterialStateProperty.all(Colors.grey.shade300),
              columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
              rows: selectedTests.map((value) {
                var currentIndex = selectedTests.indexOf(value) + 1;
                return _buildDataRowForTest(value, currentIndex);
              }).toList(),
              showBottomBorder: true,
            )
          ],
        ),
      ],
    );
  }

  DataRow _buildDataRowForTest(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text("${test.id ?? currentIndex.toString()}")),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.testName)),
      DataCell(Text(test.department)),
      DataCell(Text(test.sampleType)),
      DataCell(Text(test.turnAroundTime)),
      DataCell(Text(test.price.toString())),
      DataCell(InkWell(
        child: const Icon(Icons.delete),
        onTap: () {
          setState(() {
            selectedTests.remove(test);
            patientBloc.add(SelectedTestsUpdated(selectedTests));
            if (selectedTests.isEmpty) {
              totalPrice = 0;
            } else {
              totalPrice = totalPrice - test.price;
            }
          });
        },
      ))
    ]);
  }
}
