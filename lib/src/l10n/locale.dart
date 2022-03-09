class AppLocale {
  const AppLocale._();

  static const appTitle = 'Social Reporter';

  static const next = 'Next';
  static const submit = 'Submit';

  static const inDevelopment = 'In development';

  static const generalError = 'Error occured!';

  static const homeTitle = 'IT Спротив України';
  static const homeLoginToTelegram = 'Login to Telegram';
  static const homeLoggedInTelegram = 'Logged in to Telegram';
  static const homeLoginToYouTube = 'Login to YouTube';
  static String homeLoggedInYouTube(String email) =>
      'Logged in to YouTube as $email';
  static const homeLoginToTwitter = 'Login to Twitter';
  static const homeLoggedInTwitter = 'Logged in to Twitter';
  static const homeLoginToFacebook = 'Login to Facebook';
  static const homeLoggedInFacebook = 'Logged in to Facebook';
  static const homeLoginToInstagram = 'Login to Intagram';
  static const homeLoggedInInstagram = 'Logged in to Instagram';
  static const homeReportingInProgress =
      'Reporting in progress. Please wait...';

  static const telegramEnterPhoneTitle = 'Enter phone number';
  static const telegramEnterPhoneHint = 'Type phone number here...';
  static const telegramEnterPhoneWrongPhone = 'Entered phone is not correct!';

  static const telegramEnterOtpTitle = 'Enter OTP code';
  static const telegramEnterOtpHint = 'Type OTP code here...';
}
