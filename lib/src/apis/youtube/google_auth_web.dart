// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:social_reporter/core.dart';

class GoogleAuthInitializer {
  const GoogleAuthInitializer._();

  static void init() {
    final head = querySelector('#head') as HeadElement;
    final meta = MetaElement()
      ..name = 'google-signin-client_id'
      ..content = AppEnv.googleApiKey;
    head.children.add(meta);
  }
}
