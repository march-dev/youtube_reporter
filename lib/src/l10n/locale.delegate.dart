abstract class AppLocaleDelegate {
  String get appTitle;

  String get generalError;

  String get homeTitle;
  String get homeSubtitle;
  String get homeAbout;
  String get homePrivacy;
  String get homeLoginToGoogle;
  String homeLoggedInGoogle(String email);
  String get homeReportPossibleThreat;
  String get homeReportingInProgress;
}
