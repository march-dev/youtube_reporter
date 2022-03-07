import 'package:flutter/material.dart';
import 'package:tdlib/tdlib.dart';

import 'src/apis.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TdPlugin.initialize();

  final client = TelegramClient();
  TelegramService().init(client);

  runApp(const App());
}
