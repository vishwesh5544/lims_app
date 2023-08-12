import "dart:convert";
import "package:http/http.dart" as http;
import "package:lims_app/models/response_callback.dart";
import "package:lims_app/models/user.dart";
import "package:lims_app/network/lims_http_client.dart";
import "package:lims_app/utils/json_utils.dart";

abstract class IUserRepository {
  Future<ResponseCallback<User>> loginUser(String email, String password);
}

class UserRepository implements IUserRepository {
  final _headers = LimsHttpClient.headers;

  @override
  Future<ResponseCallback<User>> loginUser(String email, String password) async {
    ResponseCallback<User> responseCallback = ResponseCallback();
    final url = Uri.http("tomcat.queotech.in", "/api/login/log");
    var body = {"username": email, "password": password, "role": 1};

    try {
      final response = await http.post(url, body: jsonEncode(body), headers: _headers);
      var responseBody = JsonUtils.jsonStringToMap(response.body);
      responseCallback.data = User.fromMap(responseBody["data"]);
      responseCallback.code = response.statusCode;
    } on http.ClientException catch (e) {
      responseCallback.message = e.message;
      responseCallback.uri = e.uri;
    } on Exception catch (e) {
      responseCallback.message = e.toString();
    }

    return responseCallback;
  }
}
