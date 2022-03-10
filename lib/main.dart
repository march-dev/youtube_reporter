import 'package:flutter/material.dart';

import 'core.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppEnv.init();
  await SharedPref().init();
  await FirInitializer.init();
  YouTubeService().init();

  // TODO: uncomment when it works
  // if (kIsWeb) {
  //   await TdPlugin.initialize();
  // } else {
  //   await TdPlugin.initialize('libtdjson.1.8.1.dylib');
  // }

  // final client = TelegramClient();
  // TelegramService().init(client);

  runApp(const App());
}
