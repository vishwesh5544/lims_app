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
import "package:lims_app/utils/utils.dart";

import "../components/common_dropdown.dart";
import "../components/common_edit_text_filed.dart";
import "../utils/strings/add_patient_strings.dart";

class AddTest extends StatefulWidget {
  const AddTest({Key? key}) : super(key: key);

  @override
  State<AddTest> createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  late final TestBloc bloc;
  final formKey = GlobalKey<FormState>();
  // final BoxConstraints _commonBoxConstraint =
  //     const BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 40, maxHeight: 45);
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

      if (bloc.state.isAddTest && bloc.state.currentSelectedPriview != -1) {
        bloc.add(TestCodeUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].testCode));
        bloc.add(TestNameUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].testName));
        bloc.add(SampleTypeUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].sampleType));
        bloc.add(VacutainerUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].vacutainer));
        bloc.add(VolumeUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].volume));
        bloc.add(TypeOfVolumeUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].typeOfVolume));
        bloc.add(TemperatureUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].temperature));
        bloc.add(TypeOfTemperatureUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].typeOfTemperature));
        bloc.add(MethodUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].method));
        bloc.add(TurnAroundTimeUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].turnAroundTime));
        bloc.add(PriceUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].price));
        bloc.add(TaxPercentageUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].taxPercentage));
        bloc.add(TotalPriceUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].totalPrice));
        bloc.add(IndicationsUpdated(bloc.state.testsList[bloc.state.currentSelectedPriview].indications));

        sampleTypeValue = bloc.state.testsList[bloc.state.currentSelectedPriview].sampleType;
        departmentValue = bloc.state.testsList[bloc.state.currentSelectedPriview].department;
        temperatureTypeValue = bloc.state.testsList[bloc.state.currentSelectedPriview].typeOfTemperature;
        volumeTypeValue = bloc.state.testsList[bloc.state.currentSelectedPriview].typeOfVolume;
        tatValue = bloc.state.testsList[bloc.state.currentSelectedPriview].typeOfTemperature;

        testCodeEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].testCode;
        testNameEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].testName;
        sampleTypeEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].sampleType;
        vacutainerEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].vacutainer;
        volumeEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].volume;
        temperatureEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].typeOfVolume;
        methodEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].temperature;
        turnAroundTimeEditingController.text =
            bloc.state.testsList[bloc.state.currentSelectedPriview].typeOfTemperature;
        priceEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].price.toString();
        taxPercentageEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].taxPercentage.toString();
        totalPriceEditingController.text = bloc.state.testsList[bloc.state.currentSelectedPriview].totalPrice.toString();
        indicationsEditingController.text =
            bloc.state.testsList[bloc.state.currentSelectedPriview].taxPercentage.toString();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: ColorProvider.blueDarkShade),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _backButton(),
                    Text(
                      AddTestStrings.title,
                      style: TextUtility.getBoldStyle(15.0, color: Colors.white),
                    ),
                    Text(
                      "",
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
        onTap: () {
          BlocProvider.of<TestBloc>(context).add(OnAddTest());
        });
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
        return commonBtn(
          isEnable: true,
          text: AddTestStrings.title,
            calll: (){
          int price = int.parse(priceEditingController.text);
          int tax = int.parse(taxPercentageEditingController.text);
          int totalPrice = (price + (price * tax / 100)).ceil();

          AddTestFormSubmitted submitEvent;
          if (bloc.state.isAddTest && bloc.state.currentSelectedPriview != -1) {
            submitEvent = AddTestFormSubmitted(
                isUpdate: true,
                id: bloc.state.testsList[bloc.state.currentSelectedPriview].id,
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
                indications: indicationsEditingController.text);
          } else {
            submitEvent = AddTestFormSubmitted(
                isUpdate: false,
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
                indications: indicationsEditingController.text);
          }

          bloc.add(submitEvent);

          // if (state.formStatus is SubmissionSuccess) {
          Navigator.pushReplacementNamed(context, RouteStrings.viewTests);
          // }
        });
         /*ElevatedButton(
            onPressed: () {
              int price = int.parse(priceEditingController.text);
              int tax = int.parse(taxPercentageEditingController.text);
              int totalPrice = (price + (price * tax / 100)).ceil();

              AddTestFormSubmitted submitEvent;
              if (bloc.state.isAddTest && bloc.state.currentSelectedPriview != -1) {
                submitEvent = AddTestFormSubmitted(
                    isUpdate: true,
                    id: bloc.state.testsList[bloc.state.currentSelectedPriview].id,
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
                    indications: indicationsEditingController.text);
              } else {
                submitEvent = AddTestFormSubmitted(
                    isUpdate: false,
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
                    indications: indicationsEditingController.text);
              }

              bloc.add(submitEvent);

              // if (state.formStatus is SubmissionSuccess) {
              Navigator.pushReplacementNamed(context, RouteStrings.viewTests);
              // }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorProvider.blueDarkShade,
              fixedSize: const Size(150, 60),
            ),
            child: Text(AddTestStrings.title, style: TextUtility.getBoldStyle(15.0, color: Colors.white)));*/
      },
    );
  }

  /// Form text fields
  Widget _enterCodeField() {
    // var textField = TextFormField(
    //   controller: testCodeEditingController,
    //   onChanged: (value) => bloc.add(TestCodeUpdated(value)),
    //   decoration: InputDecoration(
    //       constraints: _commonBoxConstraint, border: const OutlineInputBorder(), hintText: AddTestStrings.enterCode),
    // );
    // var blocComponent = _buildBlocComponent(CommonEditText(title: 'Enter Code',
    //     hintText: AddTestStrings.enterCode,
    //     onChange: (value){bloc.add(TestCodeUpdated(value));},
    //     controller: testCodeEditingController));
    //
    //  _getColumnAndFormInput("Enter Code", blocComponent);
    return _buildBlocComponent(CommonEditText(title: 'Enter Code',
        hintText: AddTestStrings.enterCode,
        onChange: (value){bloc.add(TestCodeUpdated(value));},
        controller: testCodeEditingController));
  }

  Widget _enterTestNameField() {
    // var textField = BlocBuilder<TestBloc, TestState>(
    //   builder: (context, state) {
    //     return TextFormField(
    //       controller: testNameEditingController,
    //       onChanged: (value) => bloc.add(TestNameUpdated(value)),
    //       decoration: InputDecoration(
    //           constraints: _commonBoxConstraint,
    //           border: const OutlineInputBorder(),
    //           hintText: AddTestStrings.enterTestName),
    //     );
    //   },
    // );
    // var blocComponent = _buildBlocComponent(CommonEditText(title: 'Enter Name',
    //     hintText: AddTestStrings.enterTestName,
    //     onChange: (value){bloc.add(TestNameUpdated(value));},
    //     controller: testNameEditingController));
    // return _getColumnAndFormInput("Enter Name", blocComponent);
    return _buildBlocComponent(CommonEditText(title: 'Enter Name',
        hintText: AddTestStrings.enterTestName,
        onChange: (value){bloc.add(TestNameUpdated(value));},
        controller: testNameEditingController));
  }

  Widget _enterDetailField() {
    // var textField = BlocBuilder<TestBloc, TestState>(
    //   builder: (context, state) {
    //     return TextField(
    //       controller: vacutainerEditingController,
    //       onChanged: (value) => bloc.add(VacutainerUpdated(value)),
    //       decoration: InputDecoration(
    //           constraints: _commonBoxConstraint,
    //           border: const OutlineInputBorder(),
    //           hintText: AddTestStrings.enterDetail),
    //     );
    //   },
    // );
    // var blocComponent = _buildBlocComponent(textField);

    // return _getColumnAndFormInput("Vacutainer", blocComponent);

    return _buildBlocComponent(CommonEditText(title: 'Vacutainer',
        hintText: AddTestStrings.enterDetail,
        onChange: (value){bloc.add(VacutainerUpdated(value));},
        controller: vacutainerEditingController));
  }

  Widget _enterMethodField() {
    // var textField = TextField(
    //   controller: methodEditingController,
    //   onChanged: (value) => bloc.add(MethodUpdated(value)),
    //   decoration: InputDecoration(
    //       constraints: _commonBoxConstraint, border: const OutlineInputBorder(),
    //       hintText: AddTestStrings.enterMethod),
    // );
    // var blocComponent = _buildBlocComponent(textField);

    // return _getColumnAndFormInput("Enter method", blocComponent);

    return _buildBlocComponent(CommonEditText(title: 'Enter method',
        hintText: AddTestStrings.enterMethod,
        onChange: (value){bloc.add(MethodUpdated(value));},
        controller: methodEditingController));
  }

  Widget _priceField() {
    // var textField = TextField(
    //     controller: priceEditingController,
    //     onChanged: (value) {
    //       int price = priceEditingController.text.isNotEmpty ? int.parse(priceEditingController.text) : 0;
    //       int tax = taxPercentageEditingController.text.isNotEmpty ? int.parse(taxPercentageEditingController.text) : 0;
    //       int totalPrice = price + (price * tax);
    //       bloc.add(PriceUpdated(price));
    //       bloc.add(TotalPriceUpdated(totalPrice));
    //     },
    //     decoration: const InputDecoration(
    //         constraints: BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 40, maxHeight: 45),
    //         border: OutlineInputBorder(),
    //         hintText: AddTestStrings.enterPrice));
    // var blocComponent = _buildBlocComponent(textField);

    // return _getColumnAndFormInput("Enter price", blocComponent);

    return _buildBlocComponent(CommonEditText(title: 'Enter price',
        hintText: AddTestStrings.enterPrice,
        onChange: (value){
          int price = priceEditingController.text.isNotEmpty ? int.parse(priceEditingController.text) : 0;
          int tax = taxPercentageEditingController.text.isNotEmpty ? int.parse(taxPercentageEditingController.text) : 0;
          int totalPrice = price + (price * tax);
          bloc.add(PriceUpdated(price));
          bloc.add(TotalPriceUpdated(totalPrice));
        },
        controller: priceEditingController));
  }

  Widget _taxField() {
    // var textField = TextField(
    //     controller: taxPercentageEditingController,
    //     onChanged: (value) {
    //       int price = priceEditingController.text.isNotEmpty ? int.parse(priceEditingController.text) : 0;
    //       int tax = taxPercentageEditingController.text.isNotEmpty ? int.parse(taxPercentageEditingController.text) : 0;
    //       int totalPrice = price + (price * tax);
    //       bloc.add(TaxPercentageUpdated(tax));
    //       bloc.add(TotalPriceUpdated(totalPrice));
    //     },
    //     decoration: const InputDecoration(
    //         constraints: BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 40, maxHeight: 45),
    //         border: OutlineInputBorder(),
    //         hintText: AddTestStrings.enterTaxPercentage));
    // var blocComponent = _buildBlocComponent(textField);

    // return _getColumnAndFormInput("Enter tax", blocComponent);

    return _buildBlocComponent(CommonEditText(title: 'Enter tax',
        hintText: AddTestStrings.enterTaxPercentage,
        onChange: (value){
          int price = priceEditingController.text.isNotEmpty ? int.parse(priceEditingController.text) : 0;
          int tax = taxPercentageEditingController.text.isNotEmpty ? int.parse(taxPercentageEditingController.text) : 0;
          int totalPrice = price + (price * tax);
          bloc.add(TaxPercentageUpdated(tax));
          bloc.add(TotalPriceUpdated(totalPrice));
        },
        controller: taxPercentageEditingController));
  }

  Widget _volumeField() {
    // var textField = TextField(
    //     controller: volumeEditingController,
    //     onChanged: (value) => bloc.add(VolumeUpdated(value)),
    //     decoration: const InputDecoration(
    //         constraints: BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 40, maxHeight: 45),
    //         border: OutlineInputBorder(),
    //         hintText: AddTestStrings.enterVolume));
    //
    // var blocComponent = _buildBlocComponent(textField);
    // return _getColumnAndFormInput("Enter Value", blocComponent);

    return _buildBlocComponent(CommonEditText(title: 'Enter Value',
        hintText: AddTestStrings.enterVolume,
        onChange: (value){bloc.add(VolumeUpdated(value));},
        controller: volumeEditingController));
  }

  Widget _temperatureField() {
    // var textField = TextField(
    //     controller: temperatureEditingController,
    //     onChanged: (value) => bloc.add(TemperatureUpdated(value)),
    //     decoration: const InputDecoration(
    //         constraints: BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 40, maxHeight: 45),
    //         border: OutlineInputBorder(),
    //         hintText: AddTestStrings.enterTemperature));
    //
    // var blocComponent = _buildBlocComponent(textField);
    // return _getColumnAndFormInput("Enter Temperature", blocComponent);

    return _buildBlocComponent(CommonEditText(title: 'Enter Temperature',
        hintText: AddTestStrings.enterTemperature,
        onChange: (value){bloc.add(TemperatureUpdated(value));},
        controller: temperatureEditingController));
  }

  Widget _totalPriceField() {
    // var textField = TextField(
    //     enabled: false,
    //     readOnly: true,
    //     controller: totalPriceEditingController,
    //     onChanged: (value) => bloc.add(TotalPriceUpdated(int.parse(value))),
    //     decoration: const InputDecoration(
    //         constraints: BoxConstraints(minWidth: 100, maxWidth: 150, minHeight: 40, maxHeight: 45),
    //         border: OutlineInputBorder(),
    //         hintText: "total price"));
    // var blocComponent = _buildBlocComponent(textField);

    // return _getColumnAndFormInput("Enter price", blocComponent);


    return _buildBlocComponent(CommonEditText(title: 'Enter price',
        hintText: "total price",
        onChange: (value){bloc.add(TotalPriceUpdated(int.parse(value)));},
        controller: totalPriceEditingController));
  }

  Widget _enterObservations() {
    // var textField = TextField(
    //     controller: indicationsEditingController,
    //     onChanged: (value) => bloc.add(IndicationsUpdated(value)),
    //     maxLines: 10,
    //     decoration: const InputDecoration(
    //         constraints: BoxConstraints(minWidth: 300, maxWidth: 350, minHeight: 100, maxHeight: 150),
    //         // labelText: AddTestStrings.typeObservations,
    //         border: OutlineInputBorder(),
    //         hintText: AddTestStrings.typeObservations));
    // var blocComponent = _buildBlocComponent(textField);

    // return _getColumnAndFormInput("Indication(Observation)", blocComponent);


    return _buildBlocComponent(CommonEditText(title: 'Indication(Observation)',
        hintText: AddTestStrings.typeObservations,
        onChange: (value){bloc.add(IndicationsUpdated(value));},
        controller: indicationsEditingController));
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
    // var dropdown = DropdownButtonFormField(
    //   icon: IconStore.downwardArrow,
    //   decoration: InputDecoration(
    //     constraints: _commonBoxConstraint,
    //     border: const OutlineInputBorder(),
    //     hintText: AddTestStrings.selectType,
    //   ),
    //   items: const <DropdownMenuItem>[
    //     DropdownMenuItem(value: "one", child: Text('one')),
    //     DropdownMenuItem(value: "two", child: Text('two'))
    //   ],
    //   onChanged: (value) {
    //     setState(() {
    //       sampleTypeValue = value;
    //     });
    //   },
    // );
    // var blocComponent = _buildBlocComponent(dropdown);

    // return _getColumnAndFormInput("Sample Type", blocComponent);
    return _buildBlocComponent(CommonDropDown(title: "Sample Type",
        hintText: AddTestStrings.selectType,
        list: const ["one", "two"], onSubmit: (value){
          setState(() {
            sampleTypeValue = value;
          });
        }));
  }

  Widget _volumeTypeDropdown() {
    // var dropdown = DropdownButtonFormField(
    //   icon: IconStore.downwardArrow,
    //   decoration: InputDecoration(
    //     constraints: _commonBoxConstraint,
    //     border: const OutlineInputBorder(),
    //     hintText: AddTestStrings.enterVolume,
    //   ),
    //   items: const <DropdownMenuItem>[
    //     DropdownMenuItem(value: "mg", child: Text('mg')),
    //     DropdownMenuItem(value: "ml", child: Text('ml'))
    //   ],
    //   onChanged: (value) {
    //     setState(() {
    //       volumeTypeValue = value;
    //     });
    //   },
    // );
    // var blocComponent = _buildBlocComponent(dropdown);

    // return _getColumnAndFormInput("Volume Type", blocComponent);

    return _buildBlocComponent(CommonDropDown(title: "Volume Type",
        hintText: AddTestStrings.enterVolume,
        list: const ["mg", "ml"], onSubmit: (value){
          setState(() {
            volumeTypeValue = value;
          });
        }));
  }

  Widget _selectDepartmentDropdown() {
    // var dropdown = DropdownButtonFormField(
    //   icon: IconStore.downwardArrow,
    //   decoration: InputDecoration(
    //     constraints: _commonBoxConstraint,
    //     // labelText: AddTestStrings.selectDepartment,
    //     border: const OutlineInputBorder(),
    //     hintText: AddTestStrings.selectDepartment,
    //   ),
    //   items: const <DropdownMenuItem>[
    //     DropdownMenuItem(value: "one", child: Text('one')),
    //     DropdownMenuItem(value: "two", child: Text('two'))
    //   ],
    //   onChanged: (value) {
    //     setState(() {
    //       departmentValue = value;
    //     });
    //   },
    // );
    // var blocComponent = _buildBlocComponent(dropdown);

    // return _getColumnAndFormInput("Select department", blocComponent);

    return _buildBlocComponent(CommonDropDown(title: "Select department",
        hintText: AddTestStrings.selectDepartment,
        list: const ["one", "two"], onSubmit: (value){
          setState(() {
            departmentValue = value;
          });
        }));
  }

  Widget _enterTemperatureDropdown() {
    var dropdown = DropdownButtonFormField(
      icon: IconStore.downwardArrow,
      decoration: InputDecoration(
        hintStyle: TextUtility.getStyle(14, color: ColorProvider.darkGreyColor),
        constraints: const BoxConstraints(maxWidth: 260, minWidth: 180, minHeight: 35, maxHeight: 40),
        border: getOutLineBorder(),
        focusedErrorBorder: getOutLineBorder(),
        errorBorder: getOutLineBorder(),
        disabledBorder: getOutLineBorder(),
        enabledBorder: getOutLineBorder(),
        focusedBorder: getOutLineBorder(),
        hintText: "${AddTestStrings.enterTemperature} (\u2103/\u2109)",
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
    // var dropdown = DropdownButtonFormField(
    //   icon: IconStore.downwardArrow,
    //   decoration: InputDecoration(
    //     constraints: _commonBoxConstraint,
    //     labelText: "${AddTestStrings.enterTAT} (Hrs./days)",
    //     border: const OutlineInputBorder(),
    //     hintText: AddTestStrings.enterTemperature,
    //   ),
    //   items: const <DropdownMenuItem>[
    //     DropdownMenuItem(value: "one", child: Text('one')),
    //     DropdownMenuItem(value: "two", child: Text('two'))
    //   ],
    //   onChanged: (value) {
    //     setState(() {
    //       tatValue = value;
    //     });
    //   },
    // );
    // var blocComponent = _buildBlocComponent(dropdown);

    // return _getColumnAndFormInput("Enter TAT (Hrs./days)", blocComponent);

    return _buildBlocComponent(CommonDropDown(title: "Enter TAT (Hrs./days)",
        hintText: AddTestStrings.enterTemperature,
        list: const ["one", "two"], onSubmit: (value){
          setState(() {
            tatValue = value;
          });
        }));
  }
}
