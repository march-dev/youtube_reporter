import 'dart:ui';

import 'locale.delegate.dart';
import 'locale.en.dart';
import 'locale.ua.dart';

const ukLocale = 'uk';
const enLocale = 'en';

class AppLocale {
  const AppLocale._();

  static void init(Locale locale) {
    if (locale.languageCode == ukLocale || locale.languageCode == 'ru') {
      _locale = ukLocale;
    } else {
      _locale = enLocale;
    }
  }

  static late String _locale;

  static const _delegates = <String, AppLocaleDelegate>{
    ukLocale: AppLocaleUa(),
    enLocale: AppLocaleEn(),
  };

  static AppLocaleDelegate get _currDelegate => _delegates[_locale]!;

  static String get locale => _locale;

  static final appTitle = _currDelegate.appTitle;

  static final generalError = _currDelegate.generalError;

  static final homeTitle = _currDelegate.homeTitle;
  static final homeSubtitle = _currDelegate.homeSubtitle;
  static final homeAbout = _currDelegate.homeAbout;
  static final homePrivacy = _currDelegate.homePrivacy;
  static final homeLoginToGoogle = _currDelegate.homeLoginToGoogle;
  static String homeLoggedInGoogle(String email) =>
      _currDelegate.homeLoggedInGoogle(email);
  static final homeReportPossibleThreat =
      _currDelegate.homeReportPossibleThreat;
  static final homeReportingInProgress = _currDelegate.homeReportingInProgress;
}
