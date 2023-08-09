import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/lab_bloc/lab_bloc.dart";
import "package:lims_app/bloc/lab_bloc/lab_event.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/bloc/test_bloc/test_state.dart";
import "package:lims_app/models/lab_test_detail.dart";
import "package:lims_app/models/test.dart";
import "package:lims_app/test_items/test_data.dart";
import "package:lims_app/utils/color_provider.dart";
import "package:lims_app/utils/icons/icon_store.dart";
import "package:lims_app/utils/strings/add_centre_strings.dart";
import "package:lims_app/utils/text_utility.dart";

class AddCentre extends StatefulWidget {
  const AddCentre({Key? key}) : super(key: key);

  @override
  State<AddCentre> createState() => _AddCentreState();
}

class _AddCentreState extends State<AddCentre> {
  final BoxConstraints _commonBoxConstraint =
      const BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 40, maxHeight: 45);
  late final LabBloc bloc;
  final TextEditingController _labNameController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressOneController = TextEditingController();
  final TextEditingController _addressTwoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  List<LabTestDetail> selectedTestDetails = [];
  String unitTypeValue = "";

  @override
  void initState() {
    BlocProvider.of<TestBloc>(context).add(FetchAllTests());
    bloc = context.read<LabBloc>();

    if(bloc.state.isAddNewCenter && bloc.state.currentSelectedPriview != -1){
      _labNameController.text = bloc.state.labsList[bloc.state.currentSelectedPriview].labName;
      _emailIdController.text = bloc.state.labsList[bloc.state.currentSelectedPriview].emailId;
      _contactNumberController.text = bloc.state.labsList[bloc.state.currentSelectedPriview].contactNumber;
      _addressOneController.text = bloc.state.labsList[bloc.state.currentSelectedPriview].addressOne;
      _addressTwoController.text = bloc.state.labsList[bloc.state.currentSelectedPriview].addressTwo;
      _cityController.text = bloc.state.labsList[bloc.state.currentSelectedPriview].city;
      _stateController.text = bloc.state.labsList[bloc.state.currentSelectedPriview].state;
      _countryController.text = bloc.state.labsList[bloc.state.currentSelectedPriview].country;
      // _postalCodeController.text = bloc.state.labsList[bloc.state.currentSelectedPriview].;
      // indicationsEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].taxPercentage.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_headerStrip(), _createForm()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerStrip() {
    return Container(
      decoration: BoxDecoration(color: ColorProvider.blueDarkShade),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _backButton(),
            Text(
              AddCentreStrings.headerLabel,
              style: TextUtility.getBoldStyle(15.0, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _createForm() {
    return Form(
      child: Column(
        children: [
          Row(
            children: [_labNameField(), _emailIdField(), _contactNumberField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            children: [_addressOneField(), _addressTwoField(), _cityField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            children: [_postalCodeField(), _stateField(), _countryField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            children: [_collectionCentreDropdown()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            children: [_selectTestDropdown()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            children: [_selectedTestsTable()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_addCentreButton()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          )
        ],
      ),
    );
  }

  /// form components
  Widget _labNameField() {
    var textField = TextField(
        controller: _labNameController,
        onChanged: (value) => {},
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Name"));

    return _getColumnAndFormInput("Lab Name", textField);
  }

  Widget _emailIdField() {
    var textField = TextField(
        controller: _emailIdController,
        onChanged: (value) => {},
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Email"));

    return _getColumnAndFormInput("Email ID", textField);
  }

  Widget _contactNumberField() {
    var textField = TextField(
        controller: _contactNumberController,
        onChanged: (value) => {},
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter number"));

    return _getColumnAndFormInput("Contact Number", textField);
  }

  Widget _addressOneField() {
    var textField = TextField(
        controller: _addressOneController,
        onChanged: (value) => {},
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Type Address..."));

    return _getColumnAndFormInput("Address Line 1", textField);
  }

  Widget _addressTwoField() {
    var textField = TextField(
        controller: _addressTwoController,
        onChanged: (value) => {},
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Type Address..."));

    return _getColumnAndFormInput("Address Line 2", textField);
  }

  Widget _postalCodeField() {
    var textField = TextField(
        controller: _postalCodeController,
        onChanged: (value) => {},
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Code"));

    return _getColumnAndFormInput("Postal Code", textField);
  }

  Widget _cityField() {
    var textField = TextField(
        controller: _cityController,
        onChanged: (value) => {},
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Name"));

    return _getColumnAndFormInput("City", textField);
  }

  Widget _stateField() {
    var textField = TextField(
        controller: _stateController,
        onChanged: (value) => {},
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Name"));

    return _getColumnAndFormInput("State", textField);
  }

  Widget _countryField() {
    var textField = TextField(
        controller: _countryController,
        onChanged: (value) => {},
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Name"));

    return _getColumnAndFormInput("Country", textField);
  }

  /// form dropdowns
  Widget _collectionCentreDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        constraints: _commonBoxConstraint,
        border: const OutlineInputBorder(),
        hintText: "Select",
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "collection", child: Text('Collection Unit')),
        DropdownMenuItem(value: "processing", child: Text('Processing Unit')),
        DropdownMenuItem(value: "both", child: Text('Both')),
      ],
      onChanged: (value) {
        setState(() {
          unitTypeValue = value;
        });
      },
    );

    return _getColumnAndFormInput("Collection Centre/Processing Unit", dropdown);
  }

  Widget _selectTestDropdown() {
    var dropdown = BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        return DropdownButtonFormField(
          icon: IconStore.downwardArrow,
          decoration: const InputDecoration(
            constraints: BoxConstraints(maxWidth: 400, minWidth: 400, minHeight: 40, maxHeight: 45),
            border: OutlineInputBorder(),
            hintText: "Select Test",
          ),
          items: state.testsList.map((e) {
            return DropdownMenuItem(value: e, child: Text(e.testName));
          }).toList(),
          onChanged: (value) {
            setState(() {
              if (value != null) {
                selectedTestDetails.add(LabTestDetail(value.testName, value.testCode));
              }
            });
          },
        );
      },
    );

    return _getColumnAndFormInput("Select Test", dropdown);
  }

  /// form components util
  Widget _getColumnAndFormInput(String sectionName, Widget widget) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionName, style: TextUtility.getBoldStyle(15, color: Colors.black)),
        const SizedBox(height: 10),
        widget,
      ],
    );
  }

  /// table
  Widget _selectedTestsTable() {
    List<String> columnNames = [
      "#",
      "Test code",
      "Test name",
    ];

    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.black),
      headingTextStyle: const TextStyle(color: Colors.white),
      dataRowColor: MaterialStateProperty.all(Colors.grey.shade300),
      columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: selectedTestDetails.map((value) {
        var currentIndex = selectedTestDetails.indexOf(value) + 1;
        return _buildDataRowForTestDetail(value, currentIndex);
      }).toList(),
      showBottomBorder: true,
    );
  }

  DataRow _buildDataRowForTestDetail(LabTestDetail test, int currentIndex) {
    return DataRow(
        cells: [DataCell(Text(currentIndex.toString())), DataCell(Text(test.testCode)), DataCell(Text(test.name))]);
  }

  /// buttons
  InkWell _backButton() {
    return InkWell(
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onTap: () {
        BlocProvider.of<LabBloc>(context).add(OnAddCenter());
        });
  }

  Widget _addCentreButton() {
    return ElevatedButton(
        onPressed: () {
          bloc.add(AddCentreFormSubmitted(
              contactNumber: _contactNumberController.text,
              emailId: _emailIdController.text,
              labName: _labNameController.text,
              addressOne: _addressOneController.text,
              addressTwo: _addressTwoController.text,
              city: _cityController.text,
              country: _countryController.text,
              state: _stateController.text,
              testDetails: selectedTestDetails,
              unitType: unitTypeValue));
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            fixedSize: const Size(120, 60),
            shape: const ContinuousRectangleBorder(),
            backgroundColor: ColorProvider.blueDarkShade),
        child: const Text('Add Centre'));
  }
}
