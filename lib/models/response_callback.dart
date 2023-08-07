class ResponseCallback<T> {
  int? code;
  T? data;
  String? error;
  String? message;
  Uri? uri;

  ResponseCallback();

  bool isSuccess() {
    return code != null && code! < 400;
  }

  @override
  String toString() {
    return 'ResponseCallback{code: $code, data: $data, error: $error, message: $message}';
  }
}
