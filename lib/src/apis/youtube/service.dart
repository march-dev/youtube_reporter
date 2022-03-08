import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:social_reporter/core.dart';

class YouTubeService {
  factory YouTubeService() => _instance;
  YouTubeService._();
  static final _instance = YouTubeService._();

  late GoogleSignIn _googleSignIn;
  late YouTubeApi _youtubeApi;

  Future<void> init() async {
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        YouTubeApi.youtubeReadonlyScope,
      ],
    );
  }

  Future<bool> login() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

    final loggedIn = await _googleSignIn.isSignedIn();

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
      print('[][][] ${item.snippet?.label} ${item.id}');
      for (var secItem in item.snippet?.secondaryReasons ?? []) {
        print('[][][]   ${secItem.label} ${secItem.id}');
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
      final channels = await _youtubeApi.channels.list(
        ['snippet', 'id'],
        id: id != null ? [id] : null,
        forUsername: username,
        maxResults: 1,
      );

      channelId = channels.items!.first.id;
    }

    final result = await _youtubeApi.search.list(
      ['snippet', 'id'],
      channelId: channelId,
      order: 'date',
      maxResults: 50,
    );

    final ids = result.items
            ?.map((item) => item.id?.videoId)
            .where((id) => id != null)
            .map((id) => id!)
            .toList() ??
        <String>[];

    for (var id in ids) {
      reportVideo(id);
    }
  }

  Future<void> reportVideo(String id) {
    return _youtubeApi.videos.reportAbuse(VideoAbuseReport(
      videoId: id,
      reasonId: 'V',
      secondaryReasonId: '35',
      comments: reportAbuseComment,
    ));
  }
}
