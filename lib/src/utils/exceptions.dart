import 'package:googleapis/youtube/v3.dart';

bool isTooManyRqError(DetailedApiRequestError error) =>
    error.message ==
    'The user has sent too many requests in a given timeframe.';

bool isVideoNotFoundError(DetailedApiRequestError error) =>
    error.message ==
    'The video that you are trying to report abuse for cannot be found.';

bool isQuotaExceededError(DetailedApiRequestError error) =>
    error.message!.contains(
        'The request cannot be completed because you have exceeded your ') &&
    error.message!.contains('quota');

bool isAccessDeniedException(Object error) =>
    error.runtimeType.toString() == 'AccessDeniedException' ||
    (error.toString().contains('Access was denied') &&
        error.toString().contains('error="invalid_token"'));
