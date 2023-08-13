import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:lims_app/bloc/test_bloc/test_bloc.dart";
import "package:lims_app/bloc/test_bloc/test_event.dart";
import "package:lims_app/bloc/test_bloc/test_state.dart";
import "package:lims_app/utils/formatters.dart";
import "package:lims_app/utils/icons/icon_store.dart";
import 'package:lims_app/utils/strings/add_test_strings.dart';
import "package:lims_app/utils/color_provider.dart";
import "package:lims_app/utils/text_utility.dart";
import "package:lims_app/utils/utils.dart";
import "../components/common_dropdown.dart";
import "../components/common_edit_text_filed.dart";
import "../utils/screen_helper.dart";

class AddTest extends StatefulWidget {
  const AddTest({Key? key}) : super(key: key);

  @override
  State<AddTest> createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  late final TestBloc bloc;
  late final GlobalKey<FormBuilderState> formKey;
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

  @override
  void initState() {
    formKey = GlobalKey<FormBuilderState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<TestBloc>();

      if (bloc.state.isAddTest && bloc.state.currentSelectedPriview != -1) {
        bloc.add(TestCodeUpdated(
            bloc.state.testsList[bloc.state.currentSelectedPriview].testCode));
        bloc.add(TestNameUpdated(
            bloc.state.testsList[bloc.state.currentSelectedPriview].testName));
        bloc.add(SampleTypeUpdated(bloc
            .state.testsList[bloc.state.currentSelectedPriview].sampleType));
        bloc.add(VacutainerUpdated(bloc
            .state.testsList[bloc.state.currentSelectedPriview].vacutainer));
        bloc.add(VolumeUpdated(
            bloc.state.testsList[bloc.state.currentSelectedPriview].volume));
        bloc.add(TypeOfVolumeUpdated(bloc
            .state.testsList[bloc.state.currentSelectedPriview].typeOfVolume));
        bloc.add(TemperatureUpdated(bloc
            .state.testsList[bloc.state.currentSelectedPriview].temperature));
        bloc.add(TypeOfTemperatureUpdated(bloc.state
            .testsList[bloc.state.currentSelectedPriview].typeOfTemperature));
        bloc.add(MethodUpdated(
            bloc.state.testsList[bloc.state.currentSelectedPriview].method));
        bloc.add(TurnAroundTimeUpdated(bloc.state
            .testsList[bloc.state.currentSelectedPriview].turnAroundTime));
        bloc.add(PriceUpdated(
            bloc.state.testsList[bloc.state.currentSelectedPriview].price));
        bloc.add(TaxPercentageUpdated(bloc
            .state.testsList[bloc.state.currentSelectedPriview].taxPercentage));
        bloc.add(TotalPriceUpdated(bloc
            .state.testsList[bloc.state.currentSelectedPriview].totalPrice));
        bloc.add(IndicationsUpdated(bloc
            .state.testsList[bloc.state.currentSelectedPriview].indications));

        formKey.currentState!.fields['sampleTypeValue']?.didChange(
            bloc.state.testsList[bloc.state.currentSelectedPriview].sampleType);
        formKey.currentState!.fields['departmentValue']?.didChange(
            bloc.state.testsList[bloc.state.currentSelectedPriview].department);
        formKey.currentState!.fields['temperatureTypeValue']?.didChange(bloc
            .state
            .testsList[bloc.state.currentSelectedPriview]
            .typeOfTemperature);
        formKey.currentState!.fields['volumeTypeValue']?.didChange(bloc
            .state.testsList[bloc.state.currentSelectedPriview].typeOfVolume);
        formKey.currentState!.fields['tat']?.didChange(bloc.state
            .testsList[bloc.state.currentSelectedPriview].typeOfTemperature);

        testCodeEditingController.text =
            bloc.state.testsList[bloc.state.currentSelectedPriview].testCode;
        testNameEditingController.text =
            bloc.state.testsList[bloc.state.currentSelectedPriview].testName;
        sampleTypeEditingController.text =
            bloc.state.testsList[bloc.state.currentSelectedPriview].sampleType;
        vacutainerEditingController.text =
            bloc.state.testsList[bloc.state.currentSelectedPriview].vacutainer;
        volumeEditingController.text =
            bloc.state.testsList[bloc.state.currentSelectedPriview].volume;
        temperatureEditingController.text = bloc
            .state.testsList[bloc.state.currentSelectedPriview].typeOfVolume;
        methodEditingController.text =
            bloc.state.testsList[bloc.state.currentSelectedPriview].temperature;
        turnAroundTimeEditingController.text = bloc
            .state.testsList[bloc.state.currentSelectedPriview].turnAroundTime;
        priceEditingController.text = bloc
            .state.testsList[bloc.state.currentSelectedPriview].price
            .toString();
        taxPercentageEditingController.text = bloc
            .state.testsList[bloc.state.currentSelectedPriview].taxPercentage
            .toString();
        totalPriceEditingController.text = bloc
            .state.testsList[bloc.state.currentSelectedPriview].totalPrice
            .toString();
        indicationsEditingController.text = bloc
            .state.testsList[bloc.state.currentSelectedPriview].taxPercentage
            .toString();
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
                      style:
                          TextUtility.getBoldStyle(15.0, color: Colors.white),
                    ),
                    Text(
                      "",
                      style:
                          TextUtility.getBoldStyle(15.0, color: Colors.white),
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
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _enterCodeField(),
              _enterTestNameField(),
              _selectDepartmentDropdown()
            ]
                .map((el) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _temperatureField(),
              _enterTemperatureDropdown(),
              _selectTypeDropdown(),
              _enterDetailField()
            ]
                .map((el) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _volumeField(),
              _volumeTypeDropdown(),
              _enterMethodField()
            ]
                .map((el) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _priceField(),
              _taxField(),
              _totalPriceField(),
              _tatDropdown()
            ]
                .map((el) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_enterObservations()]
                .map((el) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: el))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [submitButton()]
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

  /// Submit button
  Widget submitButton() {
    return BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        return commonBtn(
            isEnable: true,
            text: AddTestStrings.title,
            calll: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              TestBloc bloc = BlocProvider.of<TestBloc>(context);

              int price = int.parse(priceEditingController.text);
              int tax = int.parse(taxPercentageEditingController.text);
              int totalPrice = (price + (price * tax / 100)).ceil();

              AddTestFormSubmitted submitEvent;
              if (/*bloc.state.isAddTest &&*/ bloc
                      .state.currentSelectedPriview !=
                  -1) {
                submitEvent = AddTestFormSubmitted(
                    isUpdate: true,
                    id: bloc
                        .state.testsList[bloc.state.currentSelectedPriview].id,
                    testCode: testCodeEditingController.text,
                    testName: testNameEditingController.text,
                    department: formKey.currentState!.fields['departmentValue']
                        ?.value as String,
                    temperature: temperatureEditingController.text,
                    typeOfTemperature: formKey.currentState!
                        .fields['temperatureTypeValue']?.value as String,
                    sampleType: formKey.currentState!.fields['sampleTypeValue']
                        ?.value as String,
                    vacutainer: vacutainerEditingController.text,
                    volume: volumeEditingController.text,
                    typeOfVolume: formKey.currentState!
                        .fields['volumeTypeValue']?.value as String,
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
                    department: formKey.currentState!.fields['departmentValue']
                        ?.value as String,
                    temperature: temperatureEditingController.text,
                    typeOfTemperature: formKey.currentState!
                        .fields['temperatureTypeValue']?.value as String,
                    sampleType: formKey.currentState!.fields['sampleTypeValue']
                        ?.value as String,
                    vacutainer: vacutainerEditingController.text,
                    volume: volumeEditingController.text,
                    typeOfVolume: formKey.currentState!
                        .fields['volumeTypeValue']?.value as String,
                    method: methodEditingController.text,
                    turnAroundTime: turnAroundTimeEditingController.text,
                    price: price,
                    taxPercentage: tax,
                    totalPrice: totalPrice,
                    indications: indicationsEditingController.text);
              }

              bloc.add(submitEvent);

              BlocProvider.of<TestBloc>(context).add(OnAddTest());

              ScreenHelper.showAlertPopup(
                  "Process status ${bloc.state.currentSelectedPriview != -1 ? 'added' : 'updated'} successfully",
                  context);
              // if (state.formStatus is SubmissionSuccess) {
              // Navigator.pushReplacementNamed(context, RouteStrings.viewTests);
              // }
            });
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
    return _buildBlocComponent(CommonEditText(
        title: 'Enter Code',
        name: 'code',
        hintText: AddTestStrings.enterCode,
        onChange: (value) {
          bloc.add(TestCodeUpdated(value));
        },
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
    return _buildBlocComponent(CommonEditText(
        title: 'Enter Name',
        name: 'name',
        inputFormatters: FormFormatters.name,
        hintText: AddTestStrings.enterTestName,
        onChange: (value) {
          bloc.add(TestNameUpdated(value));
        },
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

    return _buildBlocComponent(CommonEditText(
        title: 'Vacutainer',
        name: 'cacutainer',
        hintText: AddTestStrings.enterDetail,
        onChange: (value) {
          bloc.add(VacutainerUpdated(value));
        },
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

    return _buildBlocComponent(CommonEditText(
        title: 'Enter method',
        name: 'method',
        hintText: AddTestStrings.enterMethod,
        onChange: (value) {
          bloc.add(MethodUpdated(value));
        },
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

    return _buildBlocComponent(CommonEditText(
        title: 'Enter price',
        name: 'price',
        hintText: AddTestStrings.enterPrice,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9\.]+$')),
        ],
        onChange: (value) {
          int price = priceEditingController.text.isNotEmpty
              ? int.parse(priceEditingController.text)
              : 0;
          int tax = taxPercentageEditingController.text.isNotEmpty
              ? int.parse(taxPercentageEditingController.text)
              : 0;
          int totalPrice = (price + (price * tax / 100)).toInt();
          formKey.currentState!.fields['totalPrice']
              ?.didChange(totalPrice.toString());
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

    return _buildBlocComponent(CommonEditText(
        title: 'Enter tax',
        name: 'tax',
        hintText: AddTestStrings.enterTaxPercentage,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9\.]+$')),
        ],
        onChange: (value) {
          int price = priceEditingController.text.isNotEmpty
              ? int.parse(priceEditingController.text)
              : 0;
          int tax = taxPercentageEditingController.text.isNotEmpty
              ? int.parse(taxPercentageEditingController.text)
              : 0;
          int totalPrice = (price + (price * tax / 100)).toInt();
          formKey.currentState!.fields['totalPrice']
              ?.didChange(totalPrice.toString());
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

    return _buildBlocComponent(CommonEditText(
        title: 'Enter Volume',
        name: 'volume',
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9\.]+$')),
        ],
        hintText: AddTestStrings.enterVolume,
        onChange: (value) {
          bloc.add(VolumeUpdated(value));
        },
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

    return _buildBlocComponent(CommonEditText(
        title: 'Enter Temperature',
        name: 'temperature',
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        hintText: AddTestStrings.enterTemperature,
        onChange: (value) {
          bloc.add(TemperatureUpdated(value));
        },
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

    return _buildBlocComponent(
      CommonEditText(
        title: 'Total price',
        name: 'totalPrice',
        hintText: "total price",
        readOnly: true,
        onChange: (value) {
          bloc.add(TotalPriceUpdated(int.parse(value)));
        },
        controller: totalPriceEditingController,
      ),
    );
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

    return _buildBlocComponent(CommonEditText(
        title: 'Indication(Observation)',
        name: 'indication',
        hintText: AddTestStrings.typeObservations,
        onChange: (value) {
          bloc.add(IndicationsUpdated(value));
        },
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
    return _buildBlocComponent(CommonDropDown(
      title: "Sample Type",
      name: 'sampleTypeValue',
      hintText: AddTestStrings.selectType,
      list: const ["one", "two"],
      onSubmit: (value) {},
    ));
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

    return _buildBlocComponent(CommonDropDown(
        title: "Volume Type",
        name: 'volumeTypeValue',
        hintText: AddTestStrings.enterVolume,
        list: const ["mg", "ml"],
        onSubmit: (value) {}));
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

    return _buildBlocComponent(CommonDropDown(
        title: "Select department",
        name: 'departmentValue',
        hintText: AddTestStrings.selectDepartment,
        list: const ["one", "two"],
        onSubmit: (value) {}));
  }

  Widget _enterTemperatureDropdown() {
    var dropdown = Transform.translate(
      offset: const Offset(0, -5),
      child: FormBuilderDropdown(
        name: 'temperatureTypeValue',
        icon: IconStore.downwardArrow,
        decoration: InputDecoration(
          hintStyle:
              TextUtility.getStyle(14, color: ColorProvider.darkGreyColor),
          constraints: const BoxConstraints(
              maxWidth: 260, minWidth: 180, minHeight: 35, maxHeight: 55),
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
        onChanged: (value) {},
      ),
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

    return _buildBlocComponent(CommonEditText(
        title: "Enter TAT (Hrs./days)",
        name: 'tat',
        hintText: AddTestStrings.enterTAT,
        controller: turnAroundTimeEditingController,
        onChange: (v) {},
        // value: tatValue,
        onSubmit: (value) {}));
  }
}
