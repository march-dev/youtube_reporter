import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:social_reporter/core.dart';

import 'pages/home.page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) {
        AppLocale.init(Localizations.localeOf(context));
        return AppLocale.appTitle;
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale(ukLocale, ''),
        Locale(enLocale, ''),
      ],
      theme: AppTheme.materialThemeData,
      home: const HomePage(),
    );
  }
}
