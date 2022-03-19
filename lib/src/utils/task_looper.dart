import 'package:flutter/widgets.dart';
import 'package:youtube_reporter/core.dart';

const _loopDelay = Duration(minutes: 1);

final taskLoopProcessing = ValueNotifier<bool>(false);
final taskLoopCurrent = ValueNotifier<int>(0);
final taskLoopTotal = ValueNotifier<int>(0);

Future<void> youTubeTaskLoop() async {
  await Future.delayed(_loopDelay);

  if (!GoogleSignInService().isLoggedIn) {
    youTubeTaskLoop();
    return;
  }

  final lastId = YouTubeService().getLastProcessedId();
  final rawIds = await SheetsService().getYouTubeVideoIds();
  final lastIndex = lastId != null ? rawIds.indexOf(lastId) : 0;
  final ids = rawIds.skip(lastIndex + 1).toList();

  if (ids.isEmpty) {
    youTubeTaskLoop();
    return;
  }

  taskLoopProcessing.value = true;
  taskLoopTotal.value = ids.length;
  taskLoopCurrent.value = lastIndex;

  for (var i = 0; i < ids.length; i++) {
    final id = ids[i];
    await YouTubeService().reportVideo(id);
    YouTubeService().saveLastProcessedId(id);
    taskLoopCurrent.value = taskLoopCurrent.value + 1;
  }

  taskLoopProcessing.value = false;
  taskLoopCurrent.value = 0;
  taskLoopTotal.value = 0;
  youTubeTaskLoop();
}
