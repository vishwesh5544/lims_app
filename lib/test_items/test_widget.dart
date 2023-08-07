import "package:flutter/material.dart";
import "package:lims_app/components/buttons/redirect_button.dart";
import "package:lims_app/utils/strings/route_strings.dart";

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        RedirectButton(routeName: RouteStrings.viewPatients, buttonText: 'View Patients'),
        RedirectButton(routeName: RouteStrings.addPatient, buttonText: 'Add Patient'),
        RedirectButton(routeName: RouteStrings.viewTests, buttonText: 'View Tests'),
        RedirectButton(routeName: RouteStrings.addTest, buttonText: 'Add Test'),
      ].map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: e)).toList(),
    );
  }
}
