import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_reporter/core.dart';

const _keyYouTubeProcessedFiles = 'key_youtube_processed_files';

class FirStorage {
  List<Reference>? _youtubeFiles;
  Reference? _currentYouTubeFile;

  Future<List<Reference>> _getYouTubeFiles() async {
    final result = await FirebaseStorage.instance.ref('youtube/').listAll();
    final items = result.items;

    if (items.isEmpty) {
      return [];
    }

    items.sort((a, b) => a.name.compareTo(b.name));

    _youtubeFiles = items;

    return items;
  }

  Future<Reference?> _getNextYouTubeFile() async {
    final refs = _youtubeFiles?.isNotEmpty == true
        ? _youtubeFiles!
        : await _getYouTubeFiles();
    final lastFile = SharedPref().getString(_keyYouTubeProcessedFiles);

    if (lastFile == null) {
      return refs.firstOrNull;
    } else {
      _youtubeFiles =
          refs.where((item) => item.name.compareTo(lastFile) > 0).toList();
      return _youtubeFiles!.firstOrNull;
    }
  }

  Future<List<String>> getYouTubeLinks() async {
    final ref = await _getNextYouTubeFile();
    final result = <String>[];
    _currentYouTubeFile = ref;

    try {
      final data = await ref?.getData();
      if (data != null) {
        final plainStringData = utf8.decode(data);
        final links = plainStringData.split('\n');
        result.addAll(links);
      }
    } catch (e, trace) {
      logError(e, trace);
    }

    return result;
  }

  void markCurrentYouTubeFileAsProcessed() => SharedPref()
      .setString(_keyYouTubeProcessedFiles, _currentYouTubeFile!.name);
}
