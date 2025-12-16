import 'package:flutter/foundation.dart';

void logError(Exception e) {
  if (kDebugMode) {
    print('Exception: $e');
  }
}
