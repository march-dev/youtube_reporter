import 'package:flutter/material.dart';

import '../../apis.dart';
import '../../l10n/locale.dart';

const defaultCountryCode = ''; // TODO: uncomment for prod '+38';
const phoneLength = 10;
const otpLength = 5;

class TelegramAuthDialog extends StatefulWidget {
  const TelegramAuthDialog._({
    Key? key,
    required this.service,
  }) : super(key: key);

  static Future<bool> open(
    BuildContext context,
    TelegramService service,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => TelegramAuthDialog._(service: service),
    );

    return result == true;
  }

  final TelegramService service;

  @override
  State<TelegramAuthDialog> createState() => _TelegramAuthDialogState();
}

class _TelegramAuthDialogState extends State<TelegramAuthDialog> {
  bool _isOtpStep = false;

  void _onNextPressed() {
    setState(() => _isOtpStep = true);
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: !_isOtpStep
          ? _PhoneStep(
              service: widget.service,
              onNextPressed: _onNextPressed,
            )
          : _OtpStep(
              service: widget.service,
            ),
    );

    final closeButton = IconButton(
      onPressed: Navigator.of(context).pop,
      icon: const Icon(Icons.close),
    );

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 250,
        ),
        child: Stack(
          children: [
            Positioned.fill(child: content),
            Positioned(
              top: 16,
              right: 16,
              child: closeButton,
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneStep extends StatefulWidget {
  const _PhoneStep({
    Key? key,
    required this.service,
    required this.onNextPressed,
  }) : super(key: key);

  final TelegramService service;
  final VoidCallback onNextPressed;

  @override
  State<_PhoneStep> createState() => _PhoneStepState();
}

class _PhoneStepState extends State<_PhoneStep> {
  final _controller = TextEditingController();
  String? _error;

  Future<void> _onPhoneEnteredPressed() async {
    if (_controller.text.length != phoneLength) {
      setState(() {
        _error = AppLocale.telegramEnterPhoneWrongPhone;
      });
    }

    final result = await widget.service.login(
      '$defaultCountryCode${_controller.text}',
      onError: (error) {
        _error = '${AppLocale.generalError}\n${error.message}';
        if (mounted) setState(() {});
      },
    );

    if (result == TdAuthStatus.waitingOtp) {
      widget.onNextPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text(
          AppLocale.telegramEnterPhoneTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 250,
          child: TextField(
            autofocus: true,
            maxLength: phoneLength,
            controller: _controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              prefixText: defaultCountryCode,
              errorText: _error,
              hintText: AppLocale.telegramEnterPhoneHint,
              counterStyle: const TextStyle(fontSize: 0),
              counterText: '',
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: _onPhoneEnteredPressed,
          child: const Text(AppLocale.next),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _OtpStep extends StatefulWidget {
  const _OtpStep({
    Key? key,
    required this.service,
  }) : super(key: key);

  final TelegramService service;

  @override
  State<_OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<_OtpStep> {
  final _controller = TextEditingController();
  String? _error;

  void _onOtpEnteredPressed() async {
    if (_controller.text.length != otpLength) {
      setState(() {
        _error = AppLocale.telegramEnterPhoneWrongPhone;
      });
    }

    final result = await widget.service.checkOtp(
      _controller.text,
      onError: (error) {
        _error = '${AppLocale.generalError}\n${error.message}';
        if (mounted) setState(() {});
      },
    );

    if (result == TdAuthStatus.ready) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text(
          AppLocale.telegramEnterOtpTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 200,
          child: TextField(
            autofocus: true,
            maxLength: otpLength,
            controller: _controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText: _error,
              hintText: AppLocale.telegramEnterOtpHint,
              counterStyle: const TextStyle(fontSize: 0),
              counterText: '',
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: _onOtpEnteredPressed,
          child: const Text(AppLocale.submit),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
