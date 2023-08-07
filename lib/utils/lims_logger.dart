import "dart:developer" as dev;

class LimsLogger {
  static void log(String message) {
    dev.log(message, time: DateTime.now());
  }
}
