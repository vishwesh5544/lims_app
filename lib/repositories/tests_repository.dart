import 'dart:convert';
import 'package:lims_app/models/response_callback.dart';
import 'package:lims_app/models/test.dart';
import 'package:lims_app/network/lims_http_client.dart';
import "package:http/http.dart" as http;
import 'package:lims_app/utils/lims_logger.dart';
import 'package:lims_app/utils/strings/common_strings.dart';

abstract class ITestRepository {
  Future<ResponseCallback<List<Test>>> getAllTests();

  Future<ResponseCallback<Test>> addTest(Test test);
  Future<ResponseCallback<Test>> updateTest(Test test, int id);

}

class TestRepository implements ITestRepository {
  final _headers = LimsHttpClient.headers;

  @override
  Future<ResponseCallback<Test>> updateTest(Test test, int id) async {
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/tests/${id.toString()}");
    ResponseCallback<Test> responseCallback = ResponseCallback();
    try {
      var req = test.toJson();
      print(jsonEncode(req));
      final response = await http.put(url, headers: _headers, body: jsonEncode(req));
      responseCallback.code = response.statusCode;
      var responseMap = jsonDecode(response.body);
      LimsLogger.log("*** Test updated successfully => $responseMap");
      responseCallback.data = test;
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in Test Repository updateTest().");
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
  Future<ResponseCallback<Test>> addTest(Test test) async {
    ResponseCallback<Test> responseCallback = ResponseCallback();
    //TODO: make api call to add test
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/tests/add");
    try {
      final response = await http.post(url, body: jsonEncode(test.toJson()), headers: _headers);
      // final body = JsonUtils.jsonStringToMap(response.body);
      responseCallback.code = response.statusCode;
      responseCallback.data = test;
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
  Future<ResponseCallback<List<Test>>> getAllTests() async {
    ResponseCallback<List<Test>> responseCallback = ResponseCallback();
    Uri url = Uri.http(CommonStrings.apiAuthority, "/api/tests/getalltests");
    try {
      final response = await http.get(url, headers: _headers);
      List<Test> allTests = [];
      var body = jsonDecode(response.body);
      for (var test in body) {
        allTests.add(Test.fromJson(test));
      }
      responseCallback.data = allTests;
      responseCallback.code = response.statusCode;
    } on http.ClientException catch (e) {
      LimsLogger.log("*** http.ClientException in Test Repository getAllTests().");
      LimsLogger.log("Message => ${e.message}");
      LimsLogger.log("Uri => ${e.uri}");
      responseCallback.message = e.message;
      responseCallback.uri = e.uri;
    } on Exception catch (e) {
      responseCallback.message = e.toString();
    }
    // responseCallback.data = TestData.testsList();
    return responseCallback;
  }
}
