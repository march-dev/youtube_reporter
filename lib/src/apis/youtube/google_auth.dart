export 'google_auth_stub.dart'
    if (dart.library.js) 'google_auth_web.dart'
    if (dart.library.ffi) 'google_auth_native.dart';
