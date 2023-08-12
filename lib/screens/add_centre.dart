import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:lims_app/bloc/lab_bloc/lab_bloc.dart";
import "package:lims_app/bloc/lab_bloc/lab_event.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/bloc/test_bloc/test_state.dart";
import "package:lims_app/models/lab_test_detail.dart";
import "package:lims_app/models/test.dart";
import "package:lims_app/test_items/test_data.dart";
import "package:lims_app/utils/color_provider.dart";
import "package:lims_app/utils/formatters.dart";
import "package:lims_app/utils/icons/icon_store.dart";
import "package:lims_app/utils/strings/add_centre_strings.dart";
import "package:lims_app/utils/text_utility.dart";
import "package:lims_app/utils/utils.dart";

import "../components/common_dropdown.dart";
import "../components/common_edit_text_filed.dart";
import "../utils/strings/add_test_strings.dart";

class AddCentre extends StatefulWidget {
  const AddCentre({Key? key}) : super(key: key);

  @override
  State<AddCentre> createState() => _AddCentreState();
}

class _AddCentreState extends State<AddCentre> {
  late final GlobalKey<FormBuilderState> formKey;
  late final LabBloc bloc;
  final TextEditingController _labNameController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
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
    formKey = GlobalKey<FormBuilderState>();
    BlocProvider.of<TestBloc>(context).add(FetchAllTests());
    bloc = context.read<LabBloc>();

    if (bloc.state.isAddNewCenter && bloc.state.currentSelectedPriview != -1) {
      _labNameController.text =
          bloc.state.labsList[bloc.state.currentSelectedPriview].labName;
      _emailIdController.text =
          bloc.state.labsList[bloc.state.currentSelectedPriview].emailId;
      _contactNumberController.text =
          bloc.state.labsList[bloc.state.currentSelectedPriview].contactNumber;
      _addressOneController.text =
          bloc.state.labsList[bloc.state.currentSelectedPriview].addressOne;
      _addressTwoController.text =
          bloc.state.labsList[bloc.state.currentSelectedPriview].addressTwo;
      _cityController.text =
          bloc.state.labsList[bloc.state.currentSelectedPriview].city;
      _stateController.text =
          bloc.state.labsList[bloc.state.currentSelectedPriview].state;
      _countryController.text =
          bloc.state.labsList[bloc.state.currentSelectedPriview].country;
      // _postalCodeController.text = bloc.state.labsList[bloc.state.currentSelectedPriview].;
      // indicationsEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].taxPercentage.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_headerStrip(), _createForm()],
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
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [_labNameField(), _emailIdField(), _contactNumberField()]
                .map((el) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: el))
                .toList(),
          ),
          Row(
            children: [_addressOneField(), _addressTwoField(), _cityField()]
                .map((el) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: el))
                .toList(),
          ),
          Row(
            children: [_postalCodeField(), _stateField(), _countryField()]
                .map((el) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: el))
                .toList(),
          ),
          Row(
            children: [_collectionCentreDropdown()]
                .map((el) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: el))
                .toList(),
          ),
          // Row(
          //   children: [_selectTestDropdown()]
          //       .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
          //       .toList(),
          // ),
          // Row(
          //   children: [_selectedTestsTable()]
          //       .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
          //       .toList(),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_addCentreButton()]
                .map((el) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: el))
                .toList(),
          )
        ],
      ),
    );
  }

  /// form components
  Widget _labNameField() {
    // var textField = TextField(
    //     controller: _labNameController,
    //     onChanged: (value) => {},
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint, border: const OutlineInputBorder(),
    //         hintText: "Enter Name"));
    //
    // return _getColumnAndFormInput("Lab Name", textField);
    return CommonEditText(
      name: 'labName',
      title: 'Lab Name',
      inputFormatters: FormFormatters.name,
      hintText: "Enter Name",
      onChange: (value) {},
      controller: _labNameController,
    );
  }

  Widget _emailIdField() {
    // var textField = TextField(
    //     controller: _emailIdController,
    //     onChanged: (value) => {},
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Email"));

    // return _getColumnAndFormInput("Email ID", textField);
    return CommonEditText(
        name: 'labEmail',
        title: 'Lab Email',
        inputFormatters: FormFormatters.email,
        validators: [
          FormBuilderValidators.email(),
        ],
        hintText: "Enter Email",
        onChange: (value) {},
        controller: _emailIdController);
  }

  Widget _contactNumberField() {
    // var textField = TextField(
    //     controller: _contactNumberController,
    //     onChanged: (value) => {},
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter number"));

    // return _getColumnAndFormInput("Contact Number", textField);
    return CommonEditText(
        name: 'contactNumber',
        title: 'Contact Number',
        inputFormatters: FormFormatters.phone,
        hintText: "Enter number",
        onChange: (value) {},
        controller: _contactNumberController);
  }

  Widget _addressOneField() {
    // var textField = TextField(
    //     controller: _addressOneController,
    //     onChanged: (value) => {},
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Type Address..."));

    // return _getColumnAndFormInput("Address Line 1", textField);
    return CommonEditText(
        name: 'addressLine1',
        title: 'Address Line 1',
        hintText: "Type Address...",
        onChange: (value) {},
        controller: _addressOneController);
  }

  Widget _addressTwoField() {
    // var textField = TextField(
    //     controller: _addressTwoController,
    //     onChanged: (value) => {},
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Type Address..."));

    // return _getColumnAndFormInput("Address Line 2", textField);

    return CommonEditText(
        name: 'addressLine2',
        title: 'Address Line 2',
        hintText: "Type Address...",
        onChange: (value) {},
        controller: _addressTwoController);
  }

  Widget _postalCodeField() {
    // var textField = TextField(
    //     controller: _postalCodeController,
    //     onChanged: (value) => {},
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Code"));

    // return _getColumnAndFormInput("Postal Code", textField);

    return CommonEditText(
        name: 'addressLine2',
        title: 'Postal Code',
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        hintText: "Enter Code",
        onChange: (value) {},
        controller: _postalCodeController);
  }

  Widget _cityField() {
    // var textField = TextField(
    //     controller: _cityController,
    //     onChanged: (value) => {},
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Name"));

    // return _getColumnAndFormInput("City", textField);

    return CommonEditText(
        name: 'city',
        title: 'City',
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        hintText: "Enter Name",
        onChange: (value) {},
        controller: _cityController);
  }

  Widget _stateField() {
    // var textField = TextField(
    //     controller: _stateController,
    //     onChanged: (value) => {},
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Name"));

    // return _getColumnAndFormInput("State", textField);
    return CommonEditText(
        name: 'state',
        title: 'State',
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        hintText: "Enter State Name",
        onChange: (value) {},
        controller: _stateController);
  }

  Widget _countryField() {
    // var textField = TextField(
    //     controller: _countryController,
    //     onChanged: (value) => {},
    //     decoration: InputDecoration(
    //         constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Name"));

    // return _getColumnAndFormInput("Country", textField);

    return CommonEditText(
        name: 'country',
        title: 'Country',
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
        ],
        hintText: "Enter Country Name",
        onChange: (value) {},
        controller: _countryController);
  }

  /// form dropdowns
  Widget _collectionCentreDropdown() {
    String hintText = "";
    if (bloc.state.isAddNewCenter && bloc.state.currentSelectedPriview != -1) {
      hintText =
          bloc.state.labsList[bloc.state.currentSelectedPriview].unitType;
    } else {
      hintText = "Select";
    }
    // var dropdown = DropdownButtonFormField(
    //   icon: IconStore.downwardArrow,
    //   decoration: InputDecoration(
    //     constraints: _commonBoxConstraint,
    //     border: const OutlineInputBorder(),
    //     hintText:  hintText ,
    //   ),
    //   items: const <DropdownMenuItem>[
    //     DropdownMenuItem(value: "collection", child: Text('Collection Unit')),
    //     DropdownMenuItem(value: "processing", child: Text('Processing Unit')),
    //     DropdownMenuItem(value: "both", child: Text('Both')),
    //   ],
    //   onChanged: (value) {
    //     setState(() {
    //       unitTypeValue = value;
    //     });
    //   },
    // );

    // return _getColumnAndFormInput("Collection Centre/Processing Unit", dropdown);

    return CommonDropDown(
        title: "Collection Centre/Processing Unit",
        hintText: hintText,
        list: const ["Collection Unit", "Processing Unit", "Both"],
        onSubmit: (value) {
          setState(() {
            unitTypeValue = value;
          });
        });
  }

  Widget _selectTestDropdown() {
    var dropdown = BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        return DropdownButtonFormField(
          icon: IconStore.downwardArrow,
          decoration: const InputDecoration(
            constraints: BoxConstraints(
                maxWidth: 400, minWidth: 400, minHeight: 40, maxHeight: 45),
            border: OutlineInputBorder(),
            hintText: "Select Test",
          ),
          items: state.testsList.map((e) {
            return DropdownMenuItem(value: e, child: Text(e.testName));
          }).toList(),
          onChanged: (value) {
            setState(() {
              if (value != null) {
                selectedTestDetails
                    .add(LabTestDetail(value.testName, value.testCode));
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
        Text(sectionName,
            style: TextUtility.getBoldStyle(15, color: Colors.black)),
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
      columns:
          columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: selectedTestDetails.map((value) {
        var currentIndex = selectedTestDetails.indexOf(value) + 1;
        return _buildDataRowForTestDetail(value, currentIndex);
      }).toList(),
      showBottomBorder: true,
    );
  }

  DataRow _buildDataRowForTestDetail(LabTestDetail test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text(currentIndex.toString())),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.name))
    ]);
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
    return commonBtn(
        text: "Add Centre",
        isEnable: true,
        calll: () {
          if (!formKey.currentState!.validate()) {
            return;
          }
          if (selectedTestDetails.isNotEmpty && unitTypeValue.isNotEmpty) {
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
          } else {
            showDialog<void>(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                });

                return AlertDialog(
                  content: const Text(
                      "Please select Collection Unit/Processing Unit and Select Tests"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Close"))
                  ],
                );
              },
            );
          }
        });
    /*return ElevatedButton(
        onPressed: () async {
          if (selectedTestDetails.isNotEmpty && unitTypeValue.isNotEmpty) {
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
          } else {
            showDialog<void>(
              context: context,
              builder: (context) {
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.of(context).pop();
                  });

                return AlertDialog(
                  content: const Text("Please select Collection Unit/Processing Unit and Select Tests"),
                  actions: <Widget>[
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Close"))
                  ],
                );
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            fixedSize: const Size(120, 60),
            shape: const ContinuousRectangleBorder(),
            backgroundColor: ColorProvider.blueDarkShade),
        child: const Text('Add Centre'));*/
  }
}
