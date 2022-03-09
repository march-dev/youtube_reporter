import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:social_reporter/core.dart';

class YouTubeService {
  factory YouTubeService() => _instance;
  YouTubeService._();
  static final _instance = YouTubeService._();

  late GoogleSignIn _googleSignIn;
  late YouTubeApi _youtubeApi;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  String get loggedInAs => _googleSignIn.currentUser!.email;

  Future<void> init() async {
    _googleSignIn = GoogleSignIn(
      clientId: AppEnv.googleApiKey,
      scopes: [
        'email',
        YouTubeApi.youtubeReadonlyScope,
        YouTubeApi.youtubeForceSslScope,
        YouTubeApi.youtubepartnerScope,
      ],
    );
  }

  Future<bool> login() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      logError(e);
      _isLoggedIn = false;
      return false;
    }

    final loggedIn = await _googleSignIn.isSignedIn();
    _isLoggedIn = loggedIn;

    if (!loggedIn) {
      return false;
    }

    final client = await _googleSignIn.authenticatedClient();

    if (client == null) {
      return false;
    }

    _youtubeApi = YouTubeApi(client);

    return true;
  }

  Future<void> printAllAbuseReportReasons() async {
    final reasons =
        await _youtubeApi.videoAbuseReportReasons.list(['id', 'snippet']);
    for (var item in reasons.items!) {
      log('${item.snippet?.label} ${item.id}');
      for (var secItem in item.snippet?.secondaryReasons ?? []) {
        log('   ${secItem.label} ${secItem.id}');
      }
    }

    /*
    ? Video Abuse Report Reasons:

    ! Sex or nudity - N
    ! Violent, hateful, or dangerous - V
    !   Promotes violence or hatred - 35
    !   Suicide or self injury - 38
    !   Pharmaceutical or drug abuse - 39
    !   Graphic violence - 41
    !   Weapons - 43
    !   Digital security - 44
    !   Other violent, hateful, or dangerous acts - 40
    ! Child abuse - C
    ! Medical misinformation - M
    ! Violent extremism - E
    */
  }

  Future<void> reportChannelVideos({
    String? id,
    String? username,
    String? customUrl,
  }) async {
    String? channelId;

    if (customUrl != null) {
      final result = await _youtubeApi.search.list(
        ['id'],
        q: customUrl,
        type: ['channel'],
        $fields: 'items(id(kind,channelId))',
      );
      final resultItems = result.items
              ?.where((item) => item.id!.kind == 'youtube#channel')
              .toList() ??
          [];

      if (resultItems.isEmpty) {
        log('Not found channel with customUrl: $customUrl');
        return;
      }

      final channelResponse = await _youtubeApi.channels.list(
        ['snippet', 'id'],
        id: resultItems.map((item) => item.id!.channelId!).toList(),
        $fields: 'items(id,snippet(customUrl))',
        maxResults: resultItems.length,
      );
      final channelItems = channelResponse.items ?? [];

      for (var channel in channelItems) {
        if (channel.snippet?.customUrl?.isNotEmpty == true) {
          channelId = channel.id;
          break;
        }
      }
    } else {
      final result = await _youtubeApi.channels.list(
        ['snippet', 'id'],
        id: id != null ? [id] : null,
        forUsername: username,
        maxResults: 1,
      );
      final resultItems = result.items ?? [];

      if (resultItems.isEmpty) {
        log('Not found channel with id/username: $id/$username');
        return;
      }

      channelId = resultItems.first.id;
    }

    final result = await _youtubeApi.search.list(
      ['snippet', 'id'],
      channelId: channelId,
      order: 'date',
      maxResults: 25,
    );

    final ids = result.items
            ?.map((item) => item.id?.videoId)
            .where((id) => id != null)
            .map((id) => id!)
            .toList() ??
        <String>[];

    for (var id in ids) {
      await reportVideo(id);
    }
  }

  Future<void> reportVideo(String id) async {
    await _youtubeApi.videos.reportAbuse(VideoAbuseReport(
      videoId: id,
      reasonId: 'V',
      secondaryReasonId: '35',
      comments: reportAbuseComment,
    ));

    await Future.delayed(const Duration(minutes: 1));
  }
}
