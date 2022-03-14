import 'locale.delegate.dart';

class AppLocaleUa implements AppLocaleDelegate {
  const AppLocaleUa();

  @override
  final appTitle = 'YouTube Reporter';

  @override
  final generalError = 'Сталася помилка!';

  @override
  final homeTitle = 'IT Спротив України';
  @override
  final homeSubtitle = 'YouTube Скарження';
  @override
  final homeAbout = 'Про нас';
  @override
  final homePrivacy = 'Політика конфіденційності';
  @override
  final homeLoginToGoogle = 'Вхід за допомогою Google';
  @override
  String homeLoggedInGoogle(String email) => 'Вхід виконано як $email';
  @override
  final homeReportPossibleThreat = 'Надіслати потенційну загрозу на перевірку';
  @override
  final homeReportingInProgress =
      'Триває надсилання скарги. Зачекайте будь-ласка...';
}
