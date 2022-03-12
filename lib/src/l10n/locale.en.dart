import 'locale.delegate.dart';

class AppLocaleEn implements AppLocaleDelegate {
  const AppLocaleEn();

  @override
  final appTitle = 'Social Reporter';

  @override
  final next = 'Next';
  @override
  final submit = 'Submit';

  @override
  final inDevelopment = 'In development';

  @override
  final generalError = 'Error occured!';

  @override
  final homeTitle = 'IT Resistance of Ukraine';
  @override
  final homeAbout = 'About';
  @override
  final homePrivacy = 'Privacy Policy';
  @override
  final homeLoginToTelegram = 'Login to Telegram';
  @override
  final homeLoggedInTelegram = 'Logged in to Telegram';
  @override
  final homeLoginToYouTube = 'Login to YouTube';
  @override
  String homeLoggedInYouTube(String email) => 'Logged in to YouTube as $email';
  @override
  final homeReportingInProgress = 'Reporting in progress. Please wait...';

  @override
  final telegramEnterPhoneTitle = 'Enter phone number';
  @override
  final telegramEnterPhoneHint = 'Type phone number here...';
  @override
  final telegramEnterPhoneWrongPhone = 'Entered phone is not correct!';

  @override
  final telegramEnterOtpTitle = 'Enter OTP code';
  @override
  final telegramEnterOtpHint = 'Type OTP code here...';
}
