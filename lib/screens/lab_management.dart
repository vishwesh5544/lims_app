import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/lab_bloc/lab_bloc.dart";
import "package:lims_app/bloc/lab_bloc/lab_event.dart";
import "package:lims_app/bloc/lab_bloc/lab_state.dart";
import "package:lims_app/components/buttons/redirect_button.dart";
import "package:lims_app/components/lims_table.dart";
import "package:lims_app/components/search_header.dart";
import "package:lims_app/test_items/redirect_to_test_menu.dart";
import "package:lims_app/test_items/test_data.dart";
import "package:lims_app/utils/strings/button_strings.dart";
import "package:lims_app/utils/strings/route_strings.dart";
import "package:lims_app/utils/strings/search_header_strings.dart";

class LabManagement extends StatefulWidget {
  const LabManagement({Key? key}) : super(key: key);

  @override
  State<LabManagement> createState() => _LabManagementState();
}

class _LabManagementState extends State<LabManagement> {
  late final LabBloc bloc;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<LabBloc>();
      bloc.add(FetchAllLabs());
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
                    RedirectButton(buttonText: "Add New Centre", routeName: RouteStrings.addLab),
                  ],
                ),
                const SearchHeader(headerTitle: "List of Labs", placeholder: "Seach Lab"),
                BlocConsumer<LabBloc, LabState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    final columnsList = ["#", "Lab Name", "Email Id", "Contact Number", "Action"];
                    return LimsTable(columnNames: columnsList, rowData: state.labsList);
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
