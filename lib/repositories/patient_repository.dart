import 'dart:convert';

import 'package:lims_app/models/invoice_mapping.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/response_callback.dart';
import 'package:lims_app/network/lims_http_client.dart';
import 'package:lims_app/utils/lims_logger.dart';
import 'package:lims_app/utils/strings/common_strings.dart';
import "package:http/http.dart" as http;

abstract class IPatientRepository {
  Future<ResponseCallback<List<Patient>>> getAllPatients();

  Future<ResponseCallback<Patient>> addPatient(Patient patient);

  Future<ResponseCallback<List<InvoiceMapping>>> addInvoice(List<InvoiceMapping> invoiceMapping);

  Future<ResponseCallback<Patient>> updatePatient(Patient patient, int id);
}

class PatientRepository implements IPatientRepository {
  final _repositoryName = "Patient Repository";
  final _headers = LimsHttpClient.headers;

  @override
  Future<ResponseCallback<Patient>> updatePatient(Patient patient, int id) async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/Patient/${id.toString()}");
    ResponseCallback<Patient> responseCallback = ResponseCallback();
    try {
      var patch = {
        "firstname": patient.firstName,
        "middlename": patient.middleName,
        "lastname": patient.lastName,
        "DOB": patient.dob,
        "age": patient.age,
        "gender": patient.gender,
        "mobilenumber": patient.mobileNumber,
        "emailID": patient.emailId,
        "insuranceProvider": patient.insuraceProvider,
        "insuranceNumber": patient.insuraceNumber,
        "consultantDoctor": patient.consultedDoctor
      };
      final response = await http.put(url, headers: _headers, body: jsonEncode(patient.toJson()));
      responseCallback.code = response.statusCode;
      var responseMap = jsonDecode(response.body);
      LimsLogger.log("*** Patient updated successfully => $responseMap");
      responseCallback.data = patient;
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in Patient Repository addPatient().");
      LimsLogger.log("Message => ${e.message}");
      LimsLogger.log("Uri => ${e.uri}");
      responseCallback.message = e.message;
      responseCallback.uri = e.uri;
    } on Exception catch (e) {
      responseCallback.message = e.toString();
    }

    return responseCallback;
  }

  @override
  Future<ResponseCallback<Patient>> addPatient(Patient patient) async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/Patient/add");
    ResponseCallback<Patient> responseCallback = ResponseCallback();
    try {
      var req = patient.toJson();
      final response = await http.post(url, headers: _headers, body: jsonEncode(req));
      responseCallback.code = response.statusCode;
      var responseMap = jsonDecode(response.body);
      LimsLogger.log("*** Patient created successfully => $responseMap");
      responseCallback.data = Patient.fromJson(responseMap["data"][0]);
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in Patient Repository addPatient().");
      LimsLogger.log("Message => ${e.message}");
      LimsLogger.log("Uri => ${e.uri}");
      responseCallback.message = e.message;
      responseCallback.uri = e.uri;
    } on Exception catch (e) {
      responseCallback.message = e.toString();
    }

    return responseCallback;
  }

  @override
  Future<ResponseCallback<List<Patient>>> getAllPatients() async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/Patient/getallpatient");
    ResponseCallback<List<Patient>> responseCallback = ResponseCallback();
    try {
      final response = await http.get(url, headers: _headers);
      List<Patient> patients = [];
      var body = jsonDecode(response.body);
      // for (var patient in body) {
      //   print(patient.runtimeType);
      // }

      for (var patient in body) {
        patients.add(Patient.fromJson(patient));
      }
      responseCallback.data = patients;
      responseCallback.code = response.statusCode;
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in $_repositoryName getAllPatients().");
      LimsLogger.log("Message => ${e.message}");
      LimsLogger.log("Uri => ${e.uri}");
      responseCallback.message = e.message;
      responseCallback.uri = e.uri;
    } on Exception catch (e) {
      responseCallback.message = e.toString();
    }

    return responseCallback;
  }

  @override
  Future<ResponseCallback<List<InvoiceMapping>>> addInvoice(List<InvoiceMapping> invoiceMappingList) async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/testpatient/add");
    ResponseCallback<List<InvoiceMapping>> responseCallback = ResponseCallback();
    try {
      var requestBody = jsonEncode(invoiceMappingList.map((e) => e.toJson()).toList());
      final response = await http.post(url, body: requestBody, headers: _headers);
      List<InvoiceMapping> invoices = [];
      var body = jsonDecode(response.body);
      var invoiceMappingBody = body["data"][0]; // TODO: Ask backend team to send properly structured data
      for (var invoiceMapping in invoiceMappingBody) {
        invoices.add(InvoiceMapping.fromJson(invoiceMapping));
      }
      responseCallback.data = invoices;
      responseCallback.code = response.statusCode;
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in $_repositoryName addInvoice().");
      LimsLogger.log("Message => ${e.message}");
      LimsLogger.log("Uri => ${e.uri}");
      responseCallback.message = e.message;
      responseCallback.uri = e.uri;
    } on Exception catch (e) {
      responseCallback.message = e.toString();
    }

    return responseCallback;
  }
}
