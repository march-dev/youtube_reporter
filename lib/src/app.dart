import 'package:flutter/material.dart';
import 'package:social_reporter/core.dart';

import 'pages/home.page.dart';

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
