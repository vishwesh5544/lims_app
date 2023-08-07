import 'package:lims_app/components/buttons/redirect_button.dart';
import 'package:lims_app/utils/strings/route_strings.dart';

RedirectButton redirectToTestMenu() {
  return const RedirectButton(buttonText: "Redirect To Test Menu", routeName: RouteStrings.testMenu);
}
