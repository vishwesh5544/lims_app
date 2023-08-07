import 'package:http/http.dart';

class LimsHttpClient extends BaseClient {
  final String userAgent;
  final Client _client;

  LimsHttpClient(this._client, this.userAgent);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['user-agent'] = userAgent;
    request.headers['content-type'] = "application/json";

    return _client.send(request);
  }

  static Map<String, String> get headers => {
        "content-type": "application/json",
        'Accept': '*/*',
      };
}
