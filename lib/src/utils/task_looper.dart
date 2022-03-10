import 'package:flutter/widgets.dart';
import 'package:social_reporter/core.dart';

const _loopDelay = Duration(minutes: 1);

final taskLoopProcessing = ValueNotifier<bool>(false);
final taskLoopCurrent = ValueNotifier<int>(0);
final taskLoopTotal = ValueNotifier<int>(0);

Future<void> youTubeTaskLoop() async {
  await Future.delayed(_loopDelay);

  if (!YouTubeService().isLoggedIn) {
    youTubeTaskLoop();
    return;
  }

  final rawLinks = await FirStorage().getYouTubeLinks();

  if (rawLinks.isEmpty) {
    youTubeTaskLoop();
    return;
  }

  taskLoopProcessing.value = true;

  final links = rawLinks.map((link) => YouTubeLink.fromString(link)).toList();
  final videoLinks = links.where((link) => link.videoId != null).toList();
  final channelLinks = links.where((link) => link.videoId == null).toList();

  taskLoopTotal.value = videoLinks.length + channelLinks.length;

  for (var link in videoLinks) {
    await YouTubeService().reportVideo(link.videoId!).catchError(logError);
  }
  for (var link in channelLinks) {
    await YouTubeService()
        .reportChannelVideos(
          id: link.channelId,
          username: link.channelUsername,
          customUrl: link.channelCustomUrl,
        )
        .catchError(logError);
  }

  FirStorage().markCurrentYouTubeFileAsProcessed();
  taskLoopProcessing.value = false;
  taskLoopCurrent.value = 0;
  taskLoopTotal.value = 0;
  youTubeTaskLoop();
}
