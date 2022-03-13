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
  final homeLoginToYouTube = 'Login to YouTube';
  @override
  String homeLoggedInYouTube(String email) => 'Logged in to YouTube as $email';
  @override
  final homeReportPossibleThreat = 'Send potential threat to verification';
  @override
  final homeReportingInProgress = 'Reporting in progress. Please wait...';
}
