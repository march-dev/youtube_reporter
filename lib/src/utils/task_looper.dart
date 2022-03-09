import 'package:flutter/widgets.dart';
import 'package:social_reporter/core.dart';

final taskLoopProcessing = ValueNotifier<bool>(false);
final taskLoopCurrent = ValueNotifier<int>(0);
final taskLoopTotal = ValueNotifier<int>(0);

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

  taskLoopProcessing.value = true;

  try {
    final links = rawLinks.map((link) => YouTubeLink.fromString(link)).toList();
    final videoLinks = links.where((link) => link.videoId != null).toList();
    final channelLinks = links.where((link) => link.videoId == null).toList();

    taskLoopTotal.value = videoLinks.length + channelLinks.length * 25;

    for (var link in videoLinks) {
      await YouTubeService().reportVideo(link.videoId!);
      taskLoopCurrent.value = taskLoopCurrent.value + 1;
    }
    for (var link in channelLinks) {
      await YouTubeService().reportChannelVideos(
        id: link.channelId,
        username: link.channelUsername,
        customUrl: link.channelCustomUrl,
      );
      taskLoopCurrent.value = taskLoopCurrent.value + 25;
    }
  } catch (e) {
    logError(e, StackTrace.current);
  }

  taskLoopProcessing.value = false;
  taskLoopCurrent.value = 0;
  taskLoopTotal.value = 0;
  youTubeTaskLoop();
}
