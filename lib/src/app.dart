import 'package:flutter/material.dart';

import 'l10n/locale.dart';
import 'pages/home.page.dart';
import 'theme/theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocale.appTitle,
      theme: AppTheme.materialThemeData,
      home: const HomePage(),
    );
  }
}
