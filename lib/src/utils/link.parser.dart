String replaceEmoji(String value) {
  return value.replaceAll('➡️', '');
}

class YouTubeLink {
  const YouTubeLink._({
    this.videoId,
    this.channelId,
    this.channelUsername,
    this.channelCustomUrl,
  });

  factory YouTubeLink.fromString(String link) {
    final safeLink = replaceEmoji(link).trim();

    String? videoId;
    String? channelId;
    String? channelUsername;
    String? channelCustomUrl;

    const longVideoPattern = 'youtube.com/watch?v=';
    if (safeLink.contains(longVideoPattern)) {
      final start =
          safeLink.indexOf(longVideoPattern) + longVideoPattern.length;
      videoId = safeLink.substring(start);
    }

    const shortVideoPattern = 'youtu.be/';
    if (safeLink.contains(shortVideoPattern)) {
      final start =
          safeLink.indexOf(shortVideoPattern) + shortVideoPattern.length;
      videoId = safeLink.substring(start);
    }

    const shortsPattern = 'youtube.com/shorts/';
    if (safeLink.contains(shortsPattern)) {
      final start = safeLink.indexOf(shortsPattern) + shortsPattern.length;
      final end = safeLink.contains('?') ? safeLink.indexOf('?') : null;
      videoId = safeLink.substring(start, end);
    }

    const channelIdPattern = 'youtube.com/channel/';
    if (safeLink.contains(channelIdPattern)) {
      final start =
          safeLink.indexOf(channelIdPattern) + channelIdPattern.length;
      final indexOfNextSlash = safeLink.indexOf('/', start);
      final end = indexOfNextSlash != -1 ? indexOfNextSlash : null;
      channelId = safeLink.substring(start, end);
    }

    const usernamePattern = 'youtube.com/user/';
    if (safeLink.contains(usernamePattern)) {
      final start = safeLink.indexOf(usernamePattern) + usernamePattern.length;
      final indexOfNextSlash = safeLink.indexOf('/', start);
      final end = indexOfNextSlash != -1 ? indexOfNextSlash : null;
      channelUsername = safeLink.substring(start, end);
    }

    const customUrlPattern = 'youtube.com/c/';
    if (safeLink.contains(customUrlPattern)) {
      final start =
          safeLink.indexOf(customUrlPattern) + customUrlPattern.length;
      final indexOfNextSlash = safeLink.indexOf('/', start);
      final end = indexOfNextSlash != -1 ? indexOfNextSlash : null;
      channelCustomUrl = Uri.decodeComponent(safeLink.substring(start, end));
    }

    // TODO: handle short customUrl

    return YouTubeLink._(
      videoId: videoId,
      channelId: channelId,
      channelUsername: channelUsername,
      channelCustomUrl: channelCustomUrl,
    );
  }

  static bool isYouTubeLink(String link) {
    const domains = ['youtube.com', 'youtu.be'];
    return domains.any((domain) => link.contains(domain));
  }

  final String? videoId;
  final String? channelId;
  final String? channelUsername;
  final String? channelCustomUrl;
}
