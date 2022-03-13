abstract class AppLocaleDelegate {
  String get appTitle;

  String get next;
  String get submit;

  String get inDevelopment;

  String get generalError;

  String get homeTitle;
  String get homeSubtitle;
  String get homeAbout;
  String get homePrivacy;
  String get homeLoginToYouTube;
  String homeLoggedInYouTube(String email);
  String get homeReportPossibleThreat;
  String get homeReportingInProgress;

  String get telegramEnterPhoneTitle;
  String get telegramEnterPhoneHint;
  String get telegramEnterPhoneWrongPhone;

  String get telegramEnterOtpTitle;
  String get telegramEnterOtpHint;
}
