String get _logPrefix =>
    '[socialreporter][${DateTime.now().toIso8601String()}]';

void log(String message) {
  print('$_logPrefix $message');
}

void logError(Object e, [StackTrace? trace]) {
  print('$_logPrefix error: (${e.runtimeType}) $e');
  if (trace != null) {
    print('$_logPrefix trace: $trace');
  }
}
