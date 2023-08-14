import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/lab_bloc/lab_bloc.dart";
import "package:lims_app/bloc/lab_bloc/lab_event.dart";
import "package:lims_app/bloc/lab_bloc/lab_state.dart";
import "package:lims_app/components/buttons/redirect_button.dart";
import "package:lims_app/components/lims_table.dart";
import "package:lims_app/components/search_header.dart";
import "package:lims_app/utils/strings/route_strings.dart";

import "add_centre.dart";

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
      body: BlocConsumer<LabBloc, LabState>(
          listener: (context, state) {},
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                BlocProvider.of<LabBloc>(context).add(OnAddCenter());
                return true;
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: state.isAddNewCenter ? const AddCentre() : lagWidget(state)),
            );
          }),
    ));
  }

  lagWidget(LabState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RedirectButton(
                buttonText: "Add Centre",
                routeName: RouteStrings.addLab,
                onClick: () {
                  BlocProvider.of<LabBloc>(context).add(OnAddCenter(value: true));
                },
              ),
            ],
          ),
          SearchHeader(
            headerTitle: "List of Labs",
            placeholder: "Seach Lab",
            onClickSearch: () {},
          ),
          LimsTable(
              columnNames: const ["#", "Lab Name", "Email Id", "Contact Number", "Action"],
              tableType: TableType.lab,
              onEditClick: (value) {
                BlocProvider.of<LabBloc>(context).add(OnAddCenter(value: true, currentSelectedPriview: value));
              },
              onViewClick: (value) {
                BlocProvider.of<LabBloc>(context).add(OnAddCenter(value: true, currentSelectedPriview: value));
              },
              rowData: state.labsList),
          // redirectToTestMenu(),
        ].map((el) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: el)).toList(),
      ),
    );
  }
}
