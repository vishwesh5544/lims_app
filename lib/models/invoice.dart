import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/test.dart';

class Invoice {
  final String invoiceNumber;
  final Patient patient;
  final List<Test> testsList;

  Invoice(this.invoiceNumber, this.patient, this.testsList);
}