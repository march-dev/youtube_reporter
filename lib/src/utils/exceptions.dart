const youtubeReportAbuseTooManyRqErrorMessage =
    'The user has sent too many requests in a given timeframe.';
const youtubeReportAbuseVideoNotFoundErrorMessage =
    'The video that you are trying to report abuse for cannot be found.';

bool isAccessDeniedException(Object error) =>
    error.runtimeType.toString() == 'AccessDeniedException' ||
    (error.toString().contains('Access was denied') &&
        error.toString().contains('error="invalid_token"'));
