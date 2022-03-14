import 'package:flutter/material.dart';

import 'core.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppEnv.init();
  await SharedPref().init();
  await FirInitializer.init();
  await GoogleSignInService().init();

  runApp(const App());
}
