import 'locale.delegate.dart';

class AppLocaleEn implements AppLocaleDelegate {
  const AppLocaleEn();

  @override
  final appTitle = 'YouTube Reporter';

  @override
  final generalError = 'Error occured!';

  @override
  final homeTitle = 'IT Resistance of Ukraine';
  @override
  final homeSubtitle = 'YouTube Reporter';
  @override
  final homeAbout = 'About';
  @override
  final homePrivacy = 'Privacy Policy';
  @override
  final homeLoginToGoogle = 'Login via Google';
  @override
  String homeLoggedInGoogle(String email) => 'Logged in as $email';
  @override
  final homeReportPossibleThreat = 'Send potential threat to verification';
  @override
  final homeReportingInProgress = 'Reporting in progress. Please wait...';
}
