import 'package:flutter/material.dart';
import 'package:social_reporter/core.dart';

import 'telegram/auth.dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _telegramLoggedIn = false;
  bool _youtubeLoggedIn = false;
  bool _twitterLoggedIn = false;

  Future<void> _onLoginTelegramPressed() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppTheme.warningColor,
        content: Text(AppLocale.inDevelopment),
      ),
    );
    return;

    _telegramLoggedIn =
        await TelegramAuthDialog.open(context, TelegramService());
    setState(() {});
  }

  Future<void> _onLoginYouTubePressed() async {
    _youtubeLoggedIn = await YouTubeService().login();
    setState(() {});
  }

  void _onLoginTwitterPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppTheme.warningColor,
        content: Text(AppLocale.inDevelopment),
      ),
    );
  }

  @override
  void initState() {
    youTubeTaskLoop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: Column(
        children: [
          const Spacer(),
          const CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage('assets/logo.png'),
          ),
          const SizedBox(height: 8),
          const Text(
            AppLocale.homeTitle,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          const Spacer(flex: 5),
          _AdaptiveButton(
            loggedIn: _telegramLoggedIn,
            onPressed: _onLoginTelegramPressed,
            title: AppLocale.homeLoginToTelegram,
            successTextBuilder: () => AppLocale.homeLoggedInTelegram,
          ),
          const SizedBox(height: 24),
          _AdaptiveButton(
            loggedIn: _youtubeLoggedIn,
            onPressed: _onLoginYouTubePressed,
            title: AppLocale.homeLoginToYouTube,
            successTextBuilder: () =>
                AppLocale.homeLoggedInYouTube(YouTubeService().loggedInAs),
          ),
          const SizedBox(height: 24),
          _AdaptiveButton(
            loggedIn: _twitterLoggedIn,
            onPressed: _onLoginTwitterPressed,
            title: AppLocale.homeLoginToTwitter,
            successTextBuilder: () => AppLocale.homeLoggedInTwitter,
          ),
          const SizedBox(height: 24),
          const Spacer(flex: 4),
          Text(
            AppEnv.appVersion,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.onBackgroundColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _AdaptiveButton extends StatelessWidget {
  const _AdaptiveButton({
    Key? key,
    required this.loggedIn,
    required this.onPressed,
    required this.title,
    required this.successTextBuilder,
  }) : super(key: key);

  final bool loggedIn;
  final VoidCallback? onPressed;
  final String title;
  final ValueGetter<String> successTextBuilder;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (loggedIn) {
      content = _LoggedIn(text: successTextBuilder());
    } else {
      content = _Button(
        onPressed: onPressed,
        title: title,
      );
    }

    return Container(
      height: 40,
      alignment: Alignment.center,
      child: content,
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(title),
          ),
        ),
      ],
    );
  }
}

class _LoggedIn extends StatelessWidget {
  const _LoggedIn({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        const SizedBox(width: 8),
        const Icon(
          Icons.check_circle,
          color: AppTheme.successColor,
        ),
      ],
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 11,
      color: AppTheme.onBackgroundColor.withOpacity(0.5),
    );

    return ValueListenableBuilder<bool>(
      valueListenable: taskLoopProcessing,
      builder: (context, value, child) {
        return AnimatedCrossFade(
          duration: kThemeAnimationDuration,
          crossFadeState:
              value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: child!,
          secondChild: Container(),
        );
      },
      child: Column(
        children: [
          const LinearProgressIndicator(),
          const SizedBox(height: 2),
          Text(
            AppLocale.homeReportingInProgress,
            style: style,
          ),
          ValueListenableBuilder(
            valueListenable: taskLoopTotal,
            builder: (context, total, _) {
              return ValueListenableBuilder(
                valueListenable: taskLoopCurrent,
                builder: (context, current, _) {
                  return Text(
                    '$current/$total',
                    style: style,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
