import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_reporter/core.dart';

const _keyYouTubeProcessedFiles = 'key_youtube_processed_files';

class FirStorage {
  Future<List<Reference>> _getYouTubeFiles() async {
    final result = await FirebaseStorage.instance.ref('youtube/').listAll();

    final lastFile = SharedPref().getString(_keyYouTubeProcessedFiles);

    List<Reference> items;

    if (lastFile == null) {
      items = result.items;
    } else {
      items = result.items
          .where((item) => item.name.compareTo(lastFile) > 0)
          .toList();
    }

    final newLastFile =
        (items..sort((a, b) => a.name.compareTo(b.name))).last.name;
    SharedPref().setString(_keyYouTubeProcessedFiles, newLastFile);

    return items;
  }

  Future<List<String>> getYouTubeLinks() async {
    final refs = await _getYouTubeFiles();
    final result = <String>[];

    for (var ref in refs) {
      final data = await ref.getData();
      if (data != null) {
        final plainStringData = utf8.decode(data);
        final links = plainStringData.split('\n');
        result.addAll(links);
      }
    }

    return result;
  }
}
