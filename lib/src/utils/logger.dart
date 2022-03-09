void log(String message) {
  print('[socialreporter] $message');
}

void logError(Object e, [StackTrace? trace]) {
  print('[socialreporter] error: $e');
  if (trace != null) {
    print('[socialreporter] trace: $trace');
  }
}
