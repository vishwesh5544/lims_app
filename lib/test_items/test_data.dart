import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/test.dart';

class TestData {
  static List<String> testsColumnsList() {
    return [
      "#",
      "Test code",
      "Test name",
      "Department",
      "Sample type",
      "Turn Around Time (TAT)",
      "Price",
      "Actions"
    ];
  }

  static List<Test> testsList() {
    // final barcode = Barcode.code128(useCode128A: false, useCode128C: false);
    return [
      Test(
        testCode: "TEST001",
        testName: "Complete Blood Count",
        department: "Hematology",
        temperature: "Room Temperature",
        typeOfTemperature: "Not Required",
        sampleType: "Blood",
        vacutainer: "Purple Top",
        volume: "4 mL",
        typeOfVolume: "Whole Blood",
        method: "Automated Cell Counter",
        price: 250,
        taxPercentage: 5,
        totalPrice: 55,
        turnAroundTime: "1 day",
        indications: "General Health Checkup",
      ),
      Test(
        testCode: "TEST002",
        testName: "Partial Blood Count",
        department: "Hematology",
        temperature: "Room Temperature",
        typeOfTemperature: "Not Required",
        sampleType: "Blood",
        vacutainer: "Purple Top",
        volume: "4 mL",
        typeOfVolume: "Whole Blood",
        method: "Automated Cell Counter",
        price: 250,
        taxPercentage: 5,
        totalPrice: 55,
        turnAroundTime: "1 day",
        indications: "General Health Checkup",
      )
    ];
  }

  static List<Patient> patientsList() {
    return [
      Patient(
          umrNumber: "Umr121498767",
          firstName: "James",
          middleName: "sudo",
          lastName: "admin",
          dob: "23-08-2000",
          gender: "male",
          mobileNumber: 2128765493,
          emailId: "22@gmail.com",
          insuraceProvider: "vs-shukla",
          insuraceNumber: "1545-229",
          consultedDoctor: "Dr. George",
          age: '23')
    ];
  }

  static List<String> patientsColumnsList() {
    return [
      "#",
      "UMR Number",
      "Patient Name",
      "Consulted Doctor",
      "Insurance Number",
      "Mobile Number",
      "Email ID",
      "Actions"
    ];
  }
}
