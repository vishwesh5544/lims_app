import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lims_app/models/in_transit.dart';
import 'package:lims_app/models/invoice_mapping.dart';
import 'package:lims_app/models/lab.dart';
import 'package:lims_app/models/patient.dart';
import 'package:lims_app/models/patient_and_test.dart';
import 'package:lims_app/models/response_callback.dart';
import 'package:lims_app/models/search_result.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/network/lims_http_client.dart';
import 'package:lims_app/utils/lims_logger.dart';
import 'package:lims_app/utils/strings/common_strings.dart';
import "package:http/http.dart" as http;

abstract class IInTransitRepository {
  Future<ResponseCallback<PatientAndTests>> getPatientByEmail(String emailId);

  Future<ResponseCallback<InvoiceMapping>> updateInvoiceMapping(
      InTransit invoiceMapping, int invoiceId);

  Future<ResponseCallback<List<InvoiceMapping>>> getInvoiceMappingsForUser(
      int userId);

  Future<ResponseCallback<List<Lab>>> getAllFilteredLabs();

  Future<ResponseCallback<List<SearchResult>>> getSearchResultsByPtid(int ptid);

  Future<ResponseCallback<List<SearchResult>>> getSearchResultsByInvoiceId(
      int invoiceId);

  Future<ResponseCallback<List<SearchResult>>> getSearchResultsByFirstName(
      String firstname);
}

class InTransitRepository implements IInTransitRepository {
  final _repositoryName = "InTransitRepository";
  final _headers = LimsHttpClient.headers;

  @override
  Future<ResponseCallback<List<SearchResult>>> getSearchResultsByFirstName(
      String firstname) async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/tests/testlist");
    ResponseCallback<List<SearchResult>> responseCallback = ResponseCallback();

    try {
      var req = {"name": firstname};
      final response =
          await http.post(url, body: jsonEncode(req), headers: _headers);
      responseCallback.code = response.statusCode;
      var responseMap = jsonDecode(response.body);
      List<SearchResult> searchResults = [];
      for (var el in responseMap) {
        var lab = SearchResult.fromJson(el);
        searchResults.add(lab);
      }
      responseCallback.data = searchResults;

      responseCallback.code = response.statusCode;
      LimsLogger.log(
          "*** Filtered Search Results fetched successfully => $responseMap");
    } on http.ClientException catch (e) {
      LimsLogger.log(
          "*** http.ClientException in $_repositoryName getSearchResultsByFirstName().");
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
  Future<ResponseCallback<List<SearchResult>>> getSearchResultsByInvoiceId(
      int invoiceId) async {
    Uri url = Uri.http(
        CommonStrings.apiAuthority, "/api/testpatient/SearchInvoiceid");
    ResponseCallback<List<SearchResult>> responseCallback = ResponseCallback();

    try {
      var req = {"invoice_id": invoiceId};
      final response =
          await http.post(url, body: jsonEncode(req), headers: _headers);
      responseCallback.code = response.statusCode;
      var responseMap = jsonDecode(response.body);
      List<SearchResult> searchResults = [];
      for (var el in responseMap["data"]) {
        var lab = SearchResult.fromJson(el);
        searchResults.add(lab);
      }
      responseCallback.data = searchResults;
      responseCallback.code = response.statusCode;
      LimsLogger.log(
          "*** Filtered Search Results fetched successfully => $responseMap");
    } on http.ClientException catch (e) {
      LimsLogger.log(
          "*** http.ClientException in $_repositoryName getSearchResultsByInvoiceId().");
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
  Future<ResponseCallback<List<SearchResult>>> getSearchResultsByPtid(
      int ptid) async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/tests/SearchPTID");
    ResponseCallback<List<SearchResult>> responseCallback = ResponseCallback();

    try {
      var req = {"patienttestid": ptid};
      final response =
          await http.post(url, body: jsonEncode(req), headers: _headers);
      responseCallback.code = response.statusCode;
      var responseMap = jsonDecode(response.body);
      List<SearchResult> searchResults = [];
      debugPrint(responseMap);
      for (var el in responseMap["data"]) {
        var searchResult = SearchResult.fromJson(el);
        searchResults.add(searchResult);
      }
      responseCallback.data = searchResults;
      responseCallback.code = response.statusCode;
      LimsLogger.log(
          "*** Filtered Search Results fetched successfully => $responseMap");
    } on http.ClientException catch (e) {
      LimsLogger.log(
          "*** http.ClientException in $_repositoryName getSearchResultsByPtid().");
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
  Future<ResponseCallback<PatientAndTests>> getPatientByEmail(
      String emailId) async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/Patient/searchumr");
    ResponseCallback<PatientAndTests> responseCallback = ResponseCallback();
    try {
      var requestBody = {"UMR": emailId};
      final response = await http.post(url,
          body: jsonEncode(requestBody), headers: _headers);
      responseCallback.code = response.statusCode;
      var decodedJson = jsonDecode(response.body);
      var testsJson = decodedJson["tests"];
      List<Test> tests = [];
      for (var testRaw in testsJson) {
        tests.add(Test.fromJson(testRaw));
      }
      responseCallback.data =
          PatientAndTests(Patient.fromJson(decodedJson["user"]), tests);
    } on http.ClientException catch (_) {
      // LimsLogger.log("*** http.ClientException in $_repositoryName getPatientByEmail().");
      // LimsLogger.log("Message => ${e.message}");
      // LimsLogger.log("Uri => ${e.uri}");
      // responseCallback.message = e.message;
      // responseCallback.uri = e.uri;
    } on Exception catch (_) {
      // LimsLogger.log("*** Exception in $_repositoryName getPatientByFirstName().");
      // LimsLogger.log("Message => ${e.toString()}");
      // responseCallback.message = e.toString();
    }

    return responseCallback;
  }

  @override
  Future<ResponseCallback<InvoiceMapping>> updateInvoiceMapping(
      InTransit invoiceMapping, int invoiceId) async {
    Uri url = Uri.http(
        CommonStrings.apiAuthority, "/api/testpatient/${invoiceId.toString()}");
    ResponseCallback<InvoiceMapping> responseCallback = ResponseCallback();
    try {
      var requestJson = {
        "processing_unit": invoiceMapping.processingUnit,
        "collection_unit": invoiceMapping.collectionUnit,
        "status": invoiceMapping.status
      };
      var req = jsonEncode(requestJson);
      final response = await http.put(url, body: req, headers: _headers);
      responseCallback.code = response.statusCode;
      var updatedMapping =
          InvoiceMapping.fromJson(jsonDecode(response.body)["data"][0]);
      responseCallback.data = updatedMapping;
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in Test Repository addTest().");
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
  Future<ResponseCallback<List<InvoiceMapping>>> getInvoiceMappingsForUser(
      int userId) async {
    Uri url =
        Uri.http(CommonStrings.apiAuthority, "/api/testpatient/searchtests");
    ResponseCallback<List<InvoiceMapping>> responseCallback =
        ResponseCallback();
    try {
      var requestBody = {"invoice_no": userId.toString()};
      final response = await http.post(url,
          body: jsonEncode(requestBody), headers: _headers);
      // if (response.statusCode >= 200 && response.statusCode <= 299) {
      responseCallback.code = response.statusCode;
      var decodedJson = jsonDecode(response.body);
      List<InvoiceMapping> invoiceMappings = [];
      for (var mapping in decodedJson["data"]) {
        invoiceMappings.add(InvoiceMapping.fromJson(mapping));
      }
      responseCallback.data = invoiceMappings;
      // }
    } on http.ClientException catch (e) {
      LimsLogger.log(
          "*** http.ClientException in $_repositoryName getPatientByEmail().");
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
  Future<ResponseCallback<List<Lab>>> getAllFilteredLabs() async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/Labinfo/filterdata");
    ResponseCallback<List<Lab>> responseCallback = ResponseCallback();

    try {
      final response = await http.get(url, headers: _headers);
      responseCallback.code = response.statusCode;
      var responseMap = jsonDecode(response.body);
      List<Lab> labs = [];
      for (var el in responseMap) {
        var lab = Lab.fromJson(el);
        labs.add(lab);
      }
      responseCallback.data = labs;

      responseCallback.code = response.statusCode;
      LimsLogger.log("*** Filtered Labs fetched successfully => $responseMap");
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in $_repositoryName addLab().");
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
