import 'package:flutter/material.dart';
import 'package:tdlib/tdlib.dart';

import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TdPlugin.initialize();
  runApp(const App());
}
