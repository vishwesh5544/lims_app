import "package:flutter/material.dart";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
    return Form(
      child: Column(
        children: [
          Row(
            children: [_labNameField(), _emailIdField(), _contactNumberField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            children: [_addressOneField(), _addressTwoField(), _selectCityDropdown()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            children: [_postalCodeField(), _selectStateDropdown(), _selectCountryDropdown()]
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
            children: [_addCentreButton()].map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          )
        ],
      ),
    );
  }

  /// form components
  Widget _labNameField() {
    var textField = TextField(
        onChanged: (value) => {},
        maxLines: 10,
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Name"));

    return _getColumnAndFormInput("Lab Name", textField);
  }

  Widget _emailIdField() {
    var textField = TextField(
        onChanged: (value) => {},
        maxLines: 10,
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Email"));

    return _getColumnAndFormInput("Email ID", textField);
  }

  Widget _contactNumberField() {
    var textField = TextField(
        onChanged: (value) => {},
        maxLines: 10,
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter number"));

    return _getColumnAndFormInput("Contact Number", textField);
  }

  Widget _addressOneField() {
    var textField = TextField(
        onChanged: (value) => {},
        maxLines: 10,
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Type Address..."));

    return _getColumnAndFormInput("Address Line 1", textField);
  }

  Widget _addressTwoField() {
    var textField = TextField(
        onChanged: (value) => {},
        maxLines: 10,
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Type Address..."));

    return _getColumnAndFormInput("Address Line 2", textField);
  }

  Widget _postalCodeField() {
    var textField = TextField(
        onChanged: (value) => {},
        maxLines: 10,
        decoration: InputDecoration(
            constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: "Enter Code"));

    return _getColumnAndFormInput("Postal Code", textField);
  }

  /// form dropdowns
  Widget _selectCityDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        constraints: _commonBoxConstraint,
        border: const OutlineInputBorder(),
        hintText: "Select",
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "Ahmedabad", child: Text('Ahmedabad')),
        DropdownMenuItem(value: "Hyderabad", child: Text('Hyderabad'))
      ],
      onChanged: (value) {
        setState(() {});
      },
    );

    return _getColumnAndFormInput("Select City", dropdown);
  }

  Widget _selectStateDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        constraints: _commonBoxConstraint,
        border: const OutlineInputBorder(),
        hintText: "Select",
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "Gujarat", child: Text('Gujarat')),
        DropdownMenuItem(value: "Uttarakhand", child: Text('Uttarakhand'))
      ],
      onChanged: (value) {
        setState(() {});
      },
    );

    return _getColumnAndFormInput("Select State", dropdown);
  }

  Widget _selectCountryDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        constraints: _commonBoxConstraint,
        border: const OutlineInputBorder(),
        hintText: "Select",
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "India", child: Text('India')),
        DropdownMenuItem(value: "UK", child: Text('United Kingdom'))
      ],
      onChanged: (value) {
        setState(() {});
      },
    );

    return _getColumnAndFormInput("Select Country", dropdown);
  }

  Widget _collectionCentreDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        constraints: _commonBoxConstraint,
        border: const OutlineInputBorder(),
        hintText: "Select",
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "amd-unit", child: Text('Ahmedabad Unit')),
        DropdownMenuItem(value: "hyd-unit", child: Text('Hyderabad Unit'))
      ],
      onChanged: (value) {
        setState(() {});
      },
    );

    return _getColumnAndFormInput("Collection Centre/Processing Unit", dropdown);
  }

  Widget _selectTestDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: const InputDecoration(
        constraints: BoxConstraints(maxWidth: 400, minWidth: 400, minHeight: 40, maxHeight: 45),
        border: OutlineInputBorder(),
        hintText: "Select Test",
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "test-one", child: Text('Test One')),
        DropdownMenuItem(value: "test-two", child: Text('Test Two'))
      ],
      onChanged: (value) {
        setState(() {});
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
        Text(sectionName, style: TextUtility.getBoldStyle(15)),
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
      rows: TestData.testsList().map((value) {
        var currentIndex = TestData.testsList().indexOf(value) + 1;
        return _buildDataRowForTest(value, currentIndex);
      }).toList(),
      showBottomBorder: true,
    );
  }

  DataRow _buildDataRowForTest(Test test, int currentIndex) {
    return DataRow(cells: [
      DataCell(Text("${currentIndex.toString()}")),
      DataCell(Text(test.testCode)),
      DataCell(Text(test.testName))
    ]);
  }

  /// buttons
  InkWell _backButton() {
    return InkWell(
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onTap: () => {});
  }

  Widget _addCentreButton() {
    return ElevatedButton(
        child: const Text('Add Centre'),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            fixedSize: const Size(120, 60),
            shape: const ContinuousRectangleBorder(),
            backgroundColor: ColorProvider.blueDarkShade));
  }
}
