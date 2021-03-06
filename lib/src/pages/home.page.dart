import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youtube_reporter/core.dart';
import 'package:url_launcher/url_launcher.dart';

final _headerFooterStyle = TextStyle(
  fontSize: 11,
  color: AppTheme.onBackgroundColor.withOpacity(0.5),
);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _googleLoggedIn = false;

  Future<void> _onLoginYouTubePressed() async {
    _googleLoggedIn = await GoogleSignInService().login();
    await YouTubeService().init(GoogleSignInService());
    await SheetsService().init(GoogleSignInService());
    setState(() {});
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
          Text(
            AppLocale.homeTitle,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocale.homeSubtitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          const Spacer(flex: 5),
          _AdaptiveButton(
            loggedIn: _googleLoggedIn,
            onPressed: _onLoginYouTubePressed,
            title: AppLocale.homeLoginToGoogle,
            successTextBuilder: () =>
                AppLocale.homeLoggedInGoogle(GoogleSignInService().loggedInAs),
          ),
          const SizedBox(height: 24),
          const _ReportPossibleThreatButton(),
          const SizedBox(height: 24),
          const Spacer(flex: 4),
          const _Links(),
          const SizedBox(height: 4),
          Text(
            AppEnv.appVersion,
            style: _headerFooterStyle,
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
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
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

class _ReportPossibleThreatButton extends StatelessWidget {
  const _ReportPossibleThreatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: OutlinedButton(
            onPressed: () => launch('https://t.me/stopdrugsbot'),
            child: Text(
              AppLocale.homeReportPossibleThreat,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _Links extends StatelessWidget {
  const _Links({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Link(
          title: AppLocale.homeAbout,
          link: 'about.html',
        ),
        Text(' | ', style: _headerFooterStyle),
        _Link(
          title: AppLocale.homePrivacy,
          link: 'privacy.html',
        ),
      ],
    );
  }
}

class _Link extends StatefulWidget {
  const _Link({
    Key? key,
    required this.title,
    required this.link,
  }) : super(key: key);

  final String title;
  final String link;

  @override
  State<_Link> createState() => _LinkState();
}

class _LinkState extends State<_Link> {
  final _recognizer = TapGestureRecognizer();

  bool _isHovering = false;

  @override
  void initState() {
    _recognizer.onTap = () => launch(widget.link);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final style = _headerFooterStyle.copyWith(
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.solid,
      decorationColor: _headerFooterStyle.color,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Text.rich(
        TextSpan(
          text: widget.title,
          recognizer: _recognizer,
        ),
        style: _isHovering
            ? style.copyWith(
                color: AppTheme.primaryColor,
                decorationColor: AppTheme.primaryColor,
              )
            : style,
      ),
    );
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
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
            style: _headerFooterStyle,
          ),
          ValueListenableBuilder(
            valueListenable: taskLoopTotal,
            builder: (context, total, _) {
              return ValueListenableBuilder(
                valueListenable: taskLoopCurrent,
                builder: (context, current, _) {
                  return Text(
                    '$current/$total',
                    style: _headerFooterStyle,
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
