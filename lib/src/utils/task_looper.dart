import 'package:flutter/widgets.dart';
import 'package:social_reporter/core.dart';

final youTubeTaskProcessing = ValueNotifier<bool>(false);

Future<void> youTubeTaskLoop() async {
  await Future.delayed(const Duration(minutes: 1));

  if (!YouTubeService().isLoggedIn) {
    youTubeTaskLoop();
    return;
  }

  final rawLinks = await FirStorage().getYouTubeLinks();

  if (rawLinks.isEmpty) {
    youTubeTaskLoop();
    return;
  }

  youTubeTaskProcessing.value = true;

  try {
    final links = rawLinks.map((link) => YouTubeLink.fromString(link)).toList();
    final videoLinks = links.where((link) => link.videoId != null).toList();
    final channelLinks = links.where((link) => link.videoId == null).toList();

    for (var link in videoLinks) {
      await YouTubeService().reportVideo(link.videoId!);
    }
    for (var link in channelLinks) {
      await YouTubeService().reportChannelVideos(
        id: link.channelId,
        username: link.channelUsername,
        customUrl: link.channelCustomUrl,
      );
    }
  } catch (e) {
    logError(e, StackTrace.current);
  }

  youTubeTaskProcessing.value = false;
  youTubeTaskLoop();
}
