import 'package:flutter/foundation.dart';

void logError(Object error, [StackTrace? stackTrace]) {
  if (kDebugMode) {
    debugPrint('ERROR: $error');
    if (stackTrace != null) {
      debugPrint('STACKTRACE:\n$stackTrace');
    }
  }
}
