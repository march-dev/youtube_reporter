import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tdlib/tdlib.dart';

import 'core.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await TdPlugin.initialize();
  } else {
    await TdPlugin.initialize('libtdjson.1.8.1.dylib');
  }

  GoogleAuthInitializer.init();
  YouTubeService().init();

  final client = TelegramClient();
  TelegramService().init(client);

  runApp(const App());
}
