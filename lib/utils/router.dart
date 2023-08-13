import 'package:flutter/material.dart';
import "package:lims_app/main.dart";
import "package:lims_app/factory/route_factory.dart";
import "package:lims_app/screens/add_centre.dart";
import "package:lims_app/screens/test_management.dart";
import 'package:lims_app/utils/strings/route_strings.dart';
import 'package:lims_app/screens/add_patient/add_patient.dart';
import "package:lims_app/screens/add_test.dart";
import "package:lims_app/screens/patient_management.dart";

class LimsRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteStrings.landingPage:
        return LimsRouteFactory.createRoute(const App());

      case RouteStrings.viewPatients:
        return LimsRouteFactory.createRoute(const PatientManagement());

      case RouteStrings.viewTests:
        return LimsRouteFactory.createRoute(const TestManagement());

      case RouteStrings.addPatient:
        return LimsRouteFactory.createRoute(const AddPatient());

      case RouteStrings.addTest:
        return LimsRouteFactory.createRoute(const AddTest());

      // case RouteStrings.testMenu:
      //   return LimsRouteFactory.createRoute(const TestWidget());

      case RouteStrings.addLab:
        return LimsRouteFactory.createRoute(const AddCentre());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text("No route defined for ${settings.name}")),
                ));
    }
  }
}
