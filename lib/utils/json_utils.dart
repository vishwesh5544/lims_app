import 'dart:convert';

class JsonUtils {
  static Map<String, dynamic> jsonStringToMap(String jsonResponse) {
    return jsonDecode(jsonResponse);
  }
}
