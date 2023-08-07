import "package:barcode/barcode.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:intl/intl.dart";
import "package:lims_app/bloc/patient_bloc/patient_bloc.dart";
import "package:lims_app/bloc/patient_bloc/patient_event.dart";
import "package:lims_app/bloc/patient_bloc/patient_state.dart";
import "package:lims_app/screens/add_patient/patient_details_form.dart";
import "package:lims_app/screens/add_patient/test_details.dart";
import "package:lims_app/utils/barcode_utility.dart";
import "package:lims_app/utils/color_provider.dart";
import "package:lims_app/utils/strings/add_patient_strings.dart";
import "package:lims_app/utils/strings/route_strings.dart";
import "package:lims_app/utils/text_utility.dart";

import "../../components/buttons/redirect_button.dart";
import "../../utils/strings/button_strings.dart";
import "../../utils/utils.dart";

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  late final PatientBloc bloc;

  final barcode = Barcode.code128(useCode128A: false, useCode128C: false);
  late final barcodeOne = barcode.toSvg("hello LIMS", width: 200, height: 100, drawText: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc = context.read<PatientBloc>();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric( vertical: 20),
                child: Column(
                  children: [
                    _header(state),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          commonBtn(text: "Patient Details ", isEnable: state.isPatient,calll: (){
                            BlocProvider.of<PatientBloc>(context).add(IsPatient(value: true));
                          }),
                          commonBtn(text: "Add Test ", isEnable: !state.isPatient, calll: (){
                            BlocProvider.of<PatientBloc>(context).add(IsPatient());
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _getFormStepper(state),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  /// form stepper
  _getFormStepper(PatientState state) {
    // Step(title: const Text('Add Patient'), content: const PatientDetailsForm());
    //
    // const Step(title: Text('Add New details'), content: TestDetails());
    return SingleChildScrollView(
       child: state.isPatient? PatientDetailsForm() : TestDetails(),
    );
  }


  /// header strip
  Widget _header(PatientState state) {
    return Container(
      decoration: BoxDecoration(color: ColorProvider.blueDarkShade),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _backButton(state),
            Text(
              AddPatientStrings.headerText,
              style: TextUtility.getBoldStyle(15.0, color: Colors.white),
            ),
            Text(
              "",
              style: TextUtility.getBoldStyle(15.0, color: Colors.white),
            ),
            // _deleteButton()
          ],
        ),
      ),
    );
  }

  /// buttons
  InkWell _backButton(PatientState state) {
    return InkWell(
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onTap: () {
          // setState(() {
          //   state.isAddPatient = false;
          // });
          BlocProvider.of<PatientBloc>(context).add(OnAddPatient());
        });
  }

  ElevatedButton _deleteButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      child: Text('Delete', style: TextUtility.getBoldStyle(12.0)),
      onPressed: () {},
    );
  }

  Widget _getStepperButtonWithText(String buttonLabel, Function() handler) {
    final buttonStyle = ElevatedButton.styleFrom(
        shape: const ContinuousRectangleBorder(),
        backgroundColor: ColorProvider.blueDarkShade);
    return RedirectButton(buttonText: buttonLabel, routeName: RouteStrings.addPatient, onClick: (){
      // BlocProvider.of<PatientBloc>(context).add(OnAddPatient(value: true));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AddPatient()),);
      handler();
    });
    // return SizedBox(
    //   child: ElevatedButton(
    //     style: buttonStyle,
    //     onPressed: handler,
    //     child: Text(buttonLabel),
    //   ),
    // );
  }

  /// invoice dialog
  Future<void> _showInvoiceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<PatientBloc, PatientState>(
          builder: (context, state) {
            return AlertDialog(
                insetPadding: EdgeInsets.zero,
                titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                titlePadding: EdgeInsets.zero,
                title: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(color: ColorProvider.blueDarkShade),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(),
                      const Text('Invoice'),
                      InkWell(
                        child: const Icon(Icons.cancel_rounded, color: Colors.white),
                        onTap: () => Navigator.pop(context, "Cancel"),
                      )
                    ],
                  ),
                ),
                content: Container(
                  height: 500,
                  width: 800,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Text('Invoice Receipt', style: TextUtility.getBoldStyle(15))],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextUtility.getTextWithBoldAndPlain("Invoice Number", state.invoiceNumber),
                                TextUtility.getTextWithBoldAndPlain("UMR Number", state.umrNumber),
                                TextUtility.getTextWithBoldAndPlain(
                                    "Date", DateFormat("yyyy-MM-dd").format(DateTime.now())),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextUtility.getTextWithBoldAndPlain(
                                    "Patient Name", "${state.firstName} ${state.lastName}"),
                                TextUtility.getTextWithBoldAndPlain("Age/Sex", "${state.age}/${state.gender}"),
                                TextUtility.getTextWithBoldAndPlain("MobileNumber", state.mobileNumber.toString()),
                              ],
                            ),
                            Column(
                              children: [
                                SvgPicture.string(BarcodeUtility.getBarcodeSvgString(
                                    "${state.createdPatient?.id}${state.invoiceNumber}"))
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SingleChildScrollView(
                                child: SizedBox(
                              height: 200,
                              width: 400,
                              child: ListView(
                                shrinkWrap: true,
                                children: state.selectedTests.map((e) {
                                  return Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("${e.testName} => ${e.id}"),
                                      SvgPicture.string(BarcodeUtility.getBarcodeSvgString(
                                          "${state.createdPatient?.id}${state.invoiceNumber}${e.id}")),
                                    ],
                                  ),);
                                }).toList(),
                              ),
                            ))
                          ],
                        ),
                        commonBtn(text: "Generate Invoice", isEnable: true, calll: (){
                          bloc.add(GenerateInvoice());
                        }),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       bloc.add(GenerateInvoice());
                        //     },
                        //     child: const Text("Generate Invoice"))
                        // SvgPicture.string(barcodeOne)
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }
}
