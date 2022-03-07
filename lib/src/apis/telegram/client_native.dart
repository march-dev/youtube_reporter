import 'dart:async';
import 'dart:isolate';
import 'dart:math' show Random;

import 'package:flutter/foundation.dart';
import 'package:tdlib/td_api.dart';
import 'package:tdlib/tdlib.dart';

int _random() => Random().nextInt(10000000);

class TelegramClient {
  factory TelegramClient() => _instance;
  TelegramClient._() {
    init();
  }
  static final _instance = TelegramClient._();

  final _receivePort = ReceivePort();
  late Isolate _isolate;

  late int _client;
  late StreamController<TdObject> _eventController;
  late StreamSubscription<dynamic> _receiverSub;

  Map results = <int, Completer>{};
  Map callbackResults = <int, Future<void>>{};

  bool _initialized = false;

  Stream<TdObject> get events => _eventController.stream;

  /// Creates a new instance of TDLib.
  ///
  /// Sets Pointer to the created instance of TDLib [_client].
  /// Pointer 0 mean No client instance.
  Future<void> init() async {
    if (_initialized) {
      _close();
    }

    _initialized = true;

    _eventController = StreamController.broadcast();

    _client = tdCreate();

    if (kDebugMode) {
      execute(const SetLogVerbosityLevel(newVerbosityLevel: 1));
    } else {
      execute(const SetLogStream(logStream: LogStreamEmpty()));
    }

    tdSend(_client, const GetCurrentState());

    _isolate = await Isolate.spawn(
      _isolateLoop,
      _receivePort.sendPort,
      debugName: 'isolate loop',
    );
    _receiverSub = _receivePort.listen(_receiver);
  }

  static Future<void> _isolateLoop(SendPort sendPortToMain) async {
    TdNativePlugin.registerWith();
    await TdPlugin.initialize();

    while (true) {
      final s = TdPlugin.instance.tdReceive();
      if (s != null) {
        sendPortToMain.send(s);
      }
    }
  }

  Future<void> _receiver(dynamic newEvent) async {
    print('_receiver $newEvent');
    final event = convertToObject(newEvent);
    if (event == null) {
      return;
    }

    if (event is Updates) {
      for (var event in event.updates) {
        _eventController.add(event);
      }
    } else {
      _eventController.add(event);
    }

    if (event.extra == null) {
      return;
    }

    final int extraId = event.extra;
    if (results.containsKey(extraId)) {
      results.remove(extraId).complete(event);
    } else if (callbackResults.containsKey(extraId)) {
      await callbackResults.remove(extraId);
    }
  }

  /// Sends request to the TDLib client. May be called from any thread.
  Future<TdObject?> send(event, {Future<void>? callback}) async {
    final rndId = _random();

    if (callback != null) {
      callbackResults[rndId] = callback;

      try {
        tdSend(_client, event, rndId);
      } catch (e) {
        print(e);
      }

      return null;
    } else {
      final completer = Completer<TdObject>();
      results[rndId] = completer;
      tdSend(_client, event, rndId);
      return completer.future;
    }
  }

  /// Synchronously executes TDLib request. May be called from any thread.
  /// Only a few requests can be executed synchronously.
  /// Returned pointer will be deallocated by TDLib during next call to clientReceive or clientExecute in the same thread, so it can't be used after that.
  TdObject execute(TdFunction event) => tdExecute(event)!;

  Future<void> dispose() async {
    _close();
    tdSend(_client, const Close());
  }

  void _close() {
    _eventController.close();
    _receiverSub.cancel();
    _receivePort.close();
    _isolate.kill(priority: Isolate.immediate);
  }
}
