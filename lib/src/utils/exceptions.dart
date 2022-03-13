const reportAbuseTooManyRqErrorMessage =
    'The user has sent too many requests in a given timeframe.';
const reportAbuseVideoNotFoundErrorMessage =
    'The video that you are trying to report abuse for cannot be found.';
const reportAbuseQuotaExceededErrorMessage =
    'The request cannot be completed because you have exceeded your <a href="/youtube/v3/getting-started#quota">quota</a>.';

bool isAccessDeniedException(Object error) =>
    error.runtimeType.toString() == 'AccessDeniedException' ||
    (error.toString().contains('Access was denied') &&
        error.toString().contains('error="invalid_token"'));
