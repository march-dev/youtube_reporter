import 'dart:async';

import 'package:tdlib/td_api.dart';

class TelegramClient {
  Stream<TdObject> get events => throw UnimplementedError();

  /// Creates a new instance of TDLib.
  ///
  /// Sets Pointer to the created instance of TDLib [_client].
  /// Pointer 0 mean No client instance.
  Future<void> init() async => throw UnimplementedError();

  /// Sends request to the TDLib client. May be called from any thread.
  Future<TdObject?> send(event, {Future<void>? callback}) async =>
      throw UnimplementedError();

  /// Synchronously executes TDLib request. May be called from any thread.
  /// Only a few requests can be executed synchronously.
  /// Returned pointer will be deallocated by TDLib during next call to clientReceive or clientExecute in the same thread, so it can't be used after that.
  TdObject execute(TdFunction event) => throw UnimplementedError();

  Future<void> dispose() async => throw UnimplementedError();
}
