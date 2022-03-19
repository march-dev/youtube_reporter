import 'package:googleapis/youtube/v3.dart';
import 'package:youtube_reporter/core.dart';

const _reportDelay = Duration(minutes: 5);
const _retryDelay = Duration(minutes: 15);
const _reauthDelay = Duration(minutes: 60);

const _keyYouTubeLastProcessedId = 'key_youtube_last_processed_id';

class YouTubeService {
  factory YouTubeService() => _instance;
  YouTubeService._();
  static final _instance = YouTubeService._();

  late GoogleSignInService _authService;
  late YouTubeApi _youtubeApi;

  int _reauthCounter = 0;

  Future<bool> init(GoogleSignInService service) async {
    _authService = service;

    if (service.isLoggedIn) {
      _youtubeApi = YouTubeApi(_authService.client!);
    }

    return service.isLoggedIn;
  }

  Future<void> _loginSilently() async {
    final result = await _authService.loginSilently();

    if (result) {
      _youtubeApi = YouTubeApi(_authService.client!);
    }
  }

  Future<void> reportVideo(String id) async {
    log('Reporting video $id');

    try {
      await _youtubeApi.videos.reportAbuse(VideoAbuseReport(
        videoId: id,
        reasonId: 'V',
        secondaryReasonId: '35',
        comments: reportAbuseComment,
      ));
    } on DetailedApiRequestError catch (e, trace) {
      if (isTooManyRqError(e)) {
        log('Retrying in ${_retryDelay.inMinutes} minutes...');
        await Future.delayed(_retryDelay);
        await reportVideo(id);
        return;
      }
      if (isVideoNotFoundError(e)) {
        log('Video $id not found. Skipping...');
        taskLoopCurrent.value = taskLoopCurrent.value + 1;
        return;
      }
      if (isQuotaExceededError(e)) {
        final newPtDayDelay = ptTimeToNextDay();
        final hours = newPtDayDelay.inHours;
        final minutes = newPtDayDelay.inMinutes - hours * 60;
        final seconds = newPtDayDelay.inSeconds % 60;
        log('Retrying in $hours hours $minutes minutes $seconds seconds...');
        await Future.delayed(newPtDayDelay);
        await reportVideo(id);
        return;
      }

      logError(e, trace);
    } catch (e, trace) {
      if (isAccessDeniedException(e)) {
        await Future.delayed(_reauthDelay * _reauthCounter);
        _reauthCounter++;
        log('Login session ended. Creating new one...');
        await _loginSilently();
        log('New login session created. Retrying video reporting...');
        await reportVideo(id);
        return;
      }

      logError(e, trace);
    }

    _reauthCounter = 0;
    await Future.delayed(_reportDelay);
  }

  String? getLastProcessedId() =>
      SharedPref().getString(_keyYouTubeLastProcessedId);
  void saveLastProcessedId(String id) =>
      SharedPref().setString(_keyYouTubeLastProcessedId, id);
}
