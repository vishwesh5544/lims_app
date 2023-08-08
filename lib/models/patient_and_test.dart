import 'package:json_annotation/json_annotation.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/test.dart';

@JsonSerializable(explicitToJson: true)
class PatientAndTests {
  final Patient patient;
  final List<Test> tests;

  PatientAndTests(this.patient, this.tests);
}

