import 'dart:convert';

import 'package:lims_app/models/in_transit.dart';
import 'package:lims_app/models/invoice_mapping.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/patient_and_test.dart';
import 'package:lims_app/models/response_callback.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/network/lims_http_client.dart';
import 'package:lims_app/utils/lims_logger.dart';
import 'package:lims_app/utils/strings/common_strings.dart';
import "package:http/http.dart" as http;

abstract class IInTransitRepository {

  Future<ResponseCallback<PatientAndTests>> getPatientByEmail(String emailId);

  Future<ResponseCallback<InvoiceMapping>> updateInvoiceMapping(InTransit invoiceMapping, int invoiceId);

  Future<ResponseCallback<List<InvoiceMapping>>> getInvoiceMappingsForUser(int userId);
}

class InTransitRepository implements IInTransitRepository {
  final _repositoryName = "InTransitRepository";
  final _headers = LimsHttpClient.headers;

  @override
  Future<ResponseCallback<PatientAndTests>> getPatientByEmail(String emailId) async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/lms/api/Patient/searchumr");
    ResponseCallback<PatientAndTests> responseCallback = ResponseCallback();
    try {
      var requestBody = {"UMR": emailId};
      final response = await http.post(url, body: jsonEncode(requestBody), headers: _headers);
      // if (response.statusCode >= 200 && response.statusCode <= 299) {
      responseCallback.code = response.statusCode;
      var decodedJson = jsonDecode(response.body);
      var testsJson = decodedJson["tests"];
      List<Test> tests = [];
      for (var testRaw in testsJson) {
        tests.add(Test.fromJson(testRaw));
      }
      responseCallback.data = PatientAndTests(Patient.fromJson(decodedJson["user"]), tests);
      // }
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in $_repositoryName getPatientByEmail().");
      LimsLogger.log("Message => ${e.message}");
      LimsLogger.log("Uri => ${e.uri}");
      responseCallback.message = e.message;
      responseCallback.uri = e.uri;
    } on Exception catch (e) {
      LimsLogger.log("*** Exception in $_repositoryName getPatientByEmail().");
      LimsLogger.log("Message => ${e.toString()}");
      responseCallback.message = e.toString();
    }

    return responseCallback;
  }

  @override
  Future<ResponseCallback<InvoiceMapping>> updateInvoiceMapping(InTransit invoiceMapping, int invoiceId) async {
    // Uri url = Uri.http(CommonStrings.apiAuthority, "lms/api/testpatient/${invoiceId.toString()}");
    ResponseCallback<InvoiceMapping> responseCallback = ResponseCallback();
    // try {
    //   var requestJson = {
    //     "processing_unit" : invoiceMapping.processingUnit,
    //     "collection_unit": invoiceMapping.collectionUnit,
    //     "status": invoiceMapping.status ?? 2
    //   };
    //   var req = jsonEncode(requestJson);
    //   print(req);
    //   final response = await http.put(url, body: req, headers: _headers);
    //   responseCallback.code = response.statusCode;
    //   responseCallback.data = jsonDecode(response.body)["data"][0];
    // } on http.ClientException catch (e) {
    //   LimsLogger.log("*** http.ClientException in Test Repository addTest().");
    //   LimsLogger.log("Message => ${e.message}");
    //   LimsLogger.log("Uri => ${e.uri}");
    //   responseCallback.message = e.message;
    //   responseCallback.uri = e.uri;
    // } on Exception catch (e) {
    //   responseCallback.message = e.toString();
    // }

    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT', Uri.parse('http://103.174.102.117:8080/lms/api/testpatient/34'));
    request.body = json.encode({
      "processing_unit": "both",
      "collection_unit": null,
      "status": 2
    });
    request.headers.addAll(headers);

    // http.StreamedResponse response = await
    request.send().
    then((value) => print(value)).
    onError((error, stackTrace) => throw Exception(error));
    // print(response);
    //
    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // }
    // else {
    //   print(response.reasonPhrase);
    // }

    return responseCallback;
  }

  @override
  Future<ResponseCallback<List<InvoiceMapping>>> getInvoiceMappingsForUser(int userId) async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/lms/api/testpatient/searchtests");
    ResponseCallback<List<InvoiceMapping>> responseCallback = ResponseCallback();
    try {
      var requestBody = {"invoice_no": userId.toString()};
      print(requestBody);
      final response = await http.post(url, body: jsonEncode(requestBody), headers: _headers);
      // if (response.statusCode >= 200 && response.statusCode <= 299) {
      responseCallback.code = response.statusCode;
      var decodedJson = jsonDecode(response.body);
      List<InvoiceMapping> invoiceMappings = [];
      for( var mapping in decodedJson["data"]) {
        invoiceMappings.add(InvoiceMapping.fromJson(mapping));
      }
      responseCallback.data = invoiceMappings;
      // }
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in $_repositoryName getPatientByEmail().");
      LimsLogger.log("Message => ${e.message}");
      LimsLogger.log("Uri => ${e.uri}");
      responseCallback.message = e.message;
      responseCallback.uri = e.uri;
    } on Exception catch (e) {
      LimsLogger.log("*** Exception in $_repositoryName getPatientByEmail().");
      LimsLogger.log("Message => ${e.toString()}");
      responseCallback.message = e.toString();
    }

    return responseCallback;
  }
}
