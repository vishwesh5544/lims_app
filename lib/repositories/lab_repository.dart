import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:lims_app/models/lab.dart';
import 'package:lims_app/models/lab_test_detail.dart';
import 'package:lims_app/models/response_callback.dart';
import 'package:lims_app/network/lims_http_client.dart';
import 'package:lims_app/utils/lims_logger.dart';
import 'package:lims_app/utils/strings/common_strings.dart';

abstract class ILabRepository {
  Future<ResponseCallback<List<Lab>>> getAllLabs();

  Future<ResponseCallback<Lab>> addLab(Lab lab);
}

class LabRepository implements ILabRepository {
  final _repositoryName = "Lab Repository";
  final _headers = LimsHttpClient.headers;

  @override
  Future<ResponseCallback<Lab>> addLab(Lab lab) async {
    Uri url = Uri.https(CommonStrings.apiAuthority, "/lms/api/Labinfo/add");
    ResponseCallback<Lab> responseCallback = ResponseCallback();
    try {
      var r = {
        "lab_name": lab.labName,
        "email_id": lab.emailId,
        "contact_number": lab.contactNumber,
        "address_1": lab.addressOne,
        "address_2": lab.addressTwo,
        "country": lab.country,
        "state": lab.state,
        "city": lab.city,
        "unit_type": lab.unitType,
        "tests_details": lab.testDetails.toString(),
      };
      final response = await http.post(url, headers: _headers, body: jsonEncode(r));
      responseCallback.code = response.statusCode;
      responseCallback.data = lab;
      var responseMap = jsonDecode(response.body);
      LimsLogger.log("*** Lab added successfully => $responseMap");
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

  @override
  Future<ResponseCallback<List<Lab>>> getAllLabs() async {
    Uri url = Uri.https(CommonStrings.apiAuthority, "/lms/api/Labinfo/getalllabinfo");
    ResponseCallback<List<Lab>> responseCallback = ResponseCallback();

    try {
      final response = await http.get(url, headers: _headers);
      responseCallback.code = response.statusCode;
      var responseMap = jsonDecode(response.body);
      List<Lab> labs = [];
      for (var el in responseMap) {
        // var testDetails = json.decode(el['tests_details']);
        // List<LabTestDetail> testDetailsList = [];
        // for (var sml in testDetails) {
        //   var testDetail = LabTestDetail(sml["name"] as String, sml["testcode"] as String);
        //   testDetailsList.add(testDetail);
        // }

        var b = Lab(
          contactNumber: el['contact_number'] as String,
          emailId: el['email_id'] as String,
          country: el['country'] as String,
          unitType: el['unit_type'] as String,
          city: el['city'] as String,
          state: el['state'] as String,
          addressTwo: el['address_2'] as String,
          id: el['id'] as int,
          addressOne: el['address_1'] as String,
          labName: el['lab_name'] as String,
          testDetails: null,
        );
        // print(b.toJson());
        labs.add(b);
      }
      responseCallback.data = labs;

      responseCallback.code = response.statusCode;
      LimsLogger.log("*** Labs fetched successfully => $responseMap");
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
