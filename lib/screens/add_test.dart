import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/bloc/test_bloc/test_state.dart";
import "package:lims_app/test_items/redirect_to_test_menu.dart";
import "package:lims_app/utils/icons/icon_store.dart";
import 'package:lims_app/utils/strings/add_test_strings.dart';
import 'package:lims_app/utils/strings/route_strings.dart';
import "package:lims_app/utils/color_provider.dart";
import "package:lims_app/utils/text_utility.dart";

class AddTest extends StatefulWidget {
  const AddTest({Key? key}) : super(key: key);

  @override
  State<AddTest> createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  late final TestBloc bloc;
  final formKey = GlobalKey<FormState>();
  final BoxConstraints _commonBoxConstraint =
      const BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 40, maxHeight: 45);
  final testCodeEditingController = TextEditingController();
  final testNameEditingController = TextEditingController();
  final sampleTypeEditingController = TextEditingController();
  final vacutainerEditingController = TextEditingController();
  final volumeEditingController = TextEditingController();
  final temperatureEditingController = TextEditingController();
  final methodEditingController = TextEditingController();
  final turnAroundTimeEditingController = TextEditingController();
  final priceEditingController = TextEditingController();
  final taxPercentageEditingController = TextEditingController();
  final totalPriceEditingController = TextEditingController();
  final indicationsEditingController = TextEditingController();
  String sampleTypeValue = "";
  String departmentValue = "";
  String temperatureTypeValue = "";
  String volumeTypeValue = "";
  String tatValue = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<TestBloc>();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: ColorProvider.blueDarkShade),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _backButton(),
                    Text(
                      AddTestStrings.title,
                      style: TextUtility.getBoldStyle(15.0, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _createForm(),
            ),
          ],
        ),
      ),
    )));
  }

  /// buttons
  InkWell _backButton() {
    return InkWell(
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onTap: () => Navigator.pushReplacementNamed(context, RouteStrings.viewTests));
  }

  /// form element
  Widget _createForm() {
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_enterCodeField(), _enterTestNameField(), _selectDepartmentDropdown()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_temperatureField(), _enterTemperatureDropdown(), _selectTypeDropdown(), _enterDetailField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_volumeField(), _volumeTypeDropdown(), _enterMethodField()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_priceField(), _taxField(), _totalPriceField(), _tatDropdown()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_enterObservations()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [submitButton()]
                .map((el) => Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: el))
                .toList(),
          )
        ],
      ),
    );
  }

  /// Submit button
  Widget submitButton() {
    return BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        return ElevatedButton(
            onPressed: () {
              int price = int.parse(priceEditingController.text);
              int tax = int.parse(taxPercentageEditingController.text);
              int totalPrice = (price + (price * tax / 100)).ceil();
              bloc.add(AddTestFormSubmitted(
                  testCode: testCodeEditingController.text,
                  testName: testNameEditingController.text,
                  department: departmentValue,
                  temperature: temperatureEditingController.text,
                  typeOfTemperature: temperatureTypeValue,
                  sampleType: sampleTypeValue,
                  vacutainer: vacutainerEditingController.text,
                  volume: volumeEditingController.text,
                  typeOfVolume: volumeTypeValue,
                  method: methodEditingController.text,
                  turnAroundTime: turnAroundTimeEditingController.text,
                  price: price,
                  taxPercentage: tax,
                  totalPrice: totalPrice,
                  indications: indicationsEditingController.text));

              // if (state.formStatus is SubmissionSuccess) {
              Navigator.pushReplacementNamed(context, RouteStrings.viewTests);
              // }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorProvider.blueDarkShade,
              fixedSize: const Size(150, 60),
            ),
            child: Text(AddTestStrings.title, style: TextUtility.getBoldStyle(15.0, color: Colors.white)));
      },
    );
  }

  /// Form text fields
  Widget _enterCodeField() {
    var textField = TextFormField(
      controller: testCodeEditingController,
      onChanged: (value) => bloc.add(TestCodeUpdated(value)),
      decoration: InputDecoration(
          constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: AddTestStrings.enterCode),
    );
    var blocComponent = _buildBlocComponent(textField);
    return _getColumnAndFormInput("Enter Code", blocComponent);
  }

  Widget _enterTestNameField() {
    var textField = BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        return TextFormField(
          controller: testNameEditingController,
          onChanged: (value) => bloc.add(TestNameUpdated(value)),
          decoration: InputDecoration(
              constraints: _commonBoxConstraint,
              border: const OutlineInputBorder(),
              hintText: AddTestStrings.enterTestName),
        );
      },
    );
    var blocComponent = _buildBlocComponent(textField);
    return _getColumnAndFormInput("Enter Name", blocComponent);
  }

  Widget _enterDetailField() {
    var textField = BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        return TextField(
          controller: vacutainerEditingController,
          onChanged: (value) => bloc.add(VacutainerUpdated(value)),
          decoration: InputDecoration(
              constraints: _commonBoxConstraint,
              border: const OutlineInputBorder(),
              hintText: AddTestStrings.enterDetail),
        );
      },
    );
    var blocComponent = _buildBlocComponent(textField);

    return _getColumnAndFormInput("Vacutainer", blocComponent);
  }

  Widget _enterMethodField() {
    var textField = TextField(
      controller: methodEditingController,
      onChanged: (value) => bloc.add(MethodUpdated(value)),
      decoration: InputDecoration(
          constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: AddTestStrings.enterMethod),
    );
    var blocComponent = _buildBlocComponent(textField);

    return _getColumnAndFormInput("Enter method", blocComponent);
  }

  Widget _priceField() {
    var textField = TextField(
        controller: priceEditingController,
        onChanged: (value) {
          int price = priceEditingController.text.isNotEmpty ? int.parse(priceEditingController.text) : 0;
          int tax = taxPercentageEditingController.text.isNotEmpty ? int.parse(taxPercentageEditingController.text) : 0;
          int totalPrice = price + (price * tax);
          bloc.add(PriceUpdated(price));
          bloc.add(TotalPriceUpdated(totalPrice));
        },
        decoration: const InputDecoration(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 40, maxHeight: 45),
            border: OutlineInputBorder(),
            hintText: AddTestStrings.enterPrice));
    var blocComponent = _buildBlocComponent(textField);

    return _getColumnAndFormInput("Enter price", blocComponent);
  }

  Widget _taxField() {
    var textField = TextField(
        controller: taxPercentageEditingController,
        onChanged: (value) {
          int price = priceEditingController.text.isNotEmpty ? int.parse(priceEditingController.text) : 0;
          int tax = taxPercentageEditingController.text.isNotEmpty ? int.parse(taxPercentageEditingController.text) : 0;
          int totalPrice = price + (price * tax);
          bloc.add(TaxPercentageUpdated(tax));
          bloc.add(TotalPriceUpdated(totalPrice));
        },
        decoration: const InputDecoration(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 40, maxHeight: 45),
            border: OutlineInputBorder(),
            hintText: AddTestStrings.enterTaxPercentage));
    var blocComponent = _buildBlocComponent(textField);

    return _getColumnAndFormInput("Enter tax", blocComponent);
  }

  Widget _volumeField() {
    var textField = TextField(
        controller: volumeEditingController,
        onChanged: (value) => bloc.add(VolumeUpdated(value)),
        decoration: const InputDecoration(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 40, maxHeight: 45),
            border: OutlineInputBorder(),
            hintText: AddTestStrings.enterVolume));

    var blocComponent = _buildBlocComponent(textField);
    return _getColumnAndFormInput("Enter Value", blocComponent);
  }

  Widget _temperatureField() {
    var textField = TextField(
        controller: temperatureEditingController,
        onChanged: (value) => bloc.add(TemperatureUpdated(value)),
        decoration: const InputDecoration(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 40, maxHeight: 45),
            border: OutlineInputBorder(),
            hintText: AddTestStrings.enterTemperature));

    var blocComponent = _buildBlocComponent(textField);
    return _getColumnAndFormInput("Enter Temperature", blocComponent);
  }

  Widget _totalPriceField() {
    var textField = TextField(
        enabled: false,
        readOnly: true,
        controller: totalPriceEditingController,
        onChanged: (value) => bloc.add(TotalPriceUpdated(int.parse(value))),
        decoration: const InputDecoration(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 40, maxHeight: 45),
            border: OutlineInputBorder(),
            hintText: "total price"));
    var blocComponent = _buildBlocComponent(textField);

    return _getColumnAndFormInput("Enter price", blocComponent);
  }

  Widget _enterObservations() {
    var textField = TextField(
        controller: indicationsEditingController,
        onChanged: (value) => bloc.add(IndicationsUpdated(value)),
        maxLines: 10,
        decoration: const InputDecoration(
            constraints: BoxConstraints(minWidth: 300, maxWidth: 350, minHeight: 100, maxHeight: 150),
            labelText: AddTestStrings.typeObservations,
            border: OutlineInputBorder(),
            hintText: AddTestStrings.typeObservations));
    var blocComponent = _buildBlocComponent(textField);

    return _getColumnAndFormInput("Indication(Observation)", blocComponent);
  }

  /// form components util
  Widget _getColumnAndFormInput(String sectionName, Widget widget) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionName),
        const SizedBox(height: 10),
        widget,
      ],
    );
  }

  Widget _buildBlocComponent(Widget widget) {
    return BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        return widget;
      },
    );
  }

  /// Form dropdown button fields
  Widget _selectTypeDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        constraints: _commonBoxConstraint,
        border: const OutlineInputBorder(),
        hintText: AddTestStrings.selectType,
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "one", child: Text('one')),
        DropdownMenuItem(value: "two", child: Text('two'))
      ],
      onChanged: (value) {
        setState(() {
          sampleTypeValue = value;
        });
      },
    );
    var blocComponent = _buildBlocComponent(dropdown);

    return _getColumnAndFormInput("Sample Type", blocComponent);
  }

  Widget _volumeTypeDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        constraints: _commonBoxConstraint,
        border: const OutlineInputBorder(),
        hintText: AddTestStrings.enterVolume,
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "mg", child: Text('mg')),
        DropdownMenuItem(value: "ml", child: Text('ml'))
      ],
      onChanged: (value) {
        setState(() {
          volumeTypeValue = value;
        });
      },
    );
    var blocComponent = _buildBlocComponent(dropdown);

    return _getColumnAndFormInput("Volume Type", blocComponent);
  }

  Widget _selectDepartmentDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        constraints: _commonBoxConstraint,
        labelText: AddTestStrings.selectDepartment,
        border: const OutlineInputBorder(),
        hintText: AddTestStrings.selectDepartment,
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "one", child: Text('one')),
        DropdownMenuItem(value: "two", child: Text('two'))
      ],
      onChanged: (value) {
        setState(() {
          departmentValue = value;
        });
      },
    );
    var blocComponent = _buildBlocComponent(dropdown);

    return _getColumnAndFormInput("Select department", blocComponent);
  }

  Widget _enterTemperatureDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        constraints: _commonBoxConstraint,
        hintText: "${AddTestStrings.enterTemperature} (\u2103/\u2109)",
        border: const OutlineInputBorder(),
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "celsius", child: Text('\u2103')),
        DropdownMenuItem(value: "fahrenheit", child: Text('\u2109'))
      ],
      onChanged: (value) {
        setState(() {
          temperatureTypeValue = value;
        });
      },
    );
    var blocComponent = _buildBlocComponent(dropdown);

    return _getColumnAndFormInput("Temperature Type", blocComponent);
  }

  Widget _tatDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        constraints: _commonBoxConstraint,
        labelText: "${AddTestStrings.enterTAT} (Hrs./days)",
        border: const OutlineInputBorder(),
        hintText: AddTestStrings.enterTemperature,
      ),
      items: const <DropdownMenuItem>[
        DropdownMenuItem(value: "one", child: Text('one')),
        DropdownMenuItem(value: "two", child: Text('two'))
      ],
      onChanged: (value) {
        setState(() {
          tatValue = value;
        });
      },
    );
    var blocComponent = _buildBlocComponent(dropdown);

    return _getColumnAndFormInput("Enter TAT (Hrs./days)", blocComponent);
  }
}
