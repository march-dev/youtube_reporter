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

  static final next = _currDelegate.next;
  static final submit = _currDelegate.submit;

  static final inDevelopment = _currDelegate.inDevelopment;

  static final generalError = _currDelegate.generalError;

  static final homeTitle = _currDelegate.homeTitle;
  static final homeAbout = _currDelegate.homeAbout;
  static final homePrivacy = _currDelegate.homePrivacy;
  static final homeLoginToTelegram = _currDelegate.homeLoginToTelegram;
  static final homeLoggedInTelegram = _currDelegate.homeLoggedInTelegram;
  static final homeLoginToYouTube = _currDelegate.homeLoginToYouTube;
  static String homeLoggedInYouTube(String email) =>
      _currDelegate.homeLoggedInYouTube(email);
  static final homeReportingInProgress = _currDelegate.homeReportingInProgress;

  static final telegramEnterPhoneTitle = _currDelegate.telegramEnterPhoneTitle;
  static final telegramEnterPhoneHint = _currDelegate.telegramEnterPhoneHint;
  static final telegramEnterPhoneWrongPhone =
      _currDelegate.telegramEnterPhoneWrongPhone;

  static final telegramEnterOtpTitle = _currDelegate.telegramEnterOtpTitle;
  static final telegramEnterOtpHint = _currDelegate.telegramEnterOtpHint;
}
