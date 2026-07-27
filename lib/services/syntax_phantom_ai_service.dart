class SyntaxPhantomAIService {
  static const bannedWords = [
    'nudity',
    'nude',
    'porn',
    'porno',
    'sexual',
    'sex service',
    'escort',
    'racist',
    'hate',
    'harass',
    'threat',
    'kill',
    'scam',
    'fraud',
  ];

  static Future<Map<String, String>> scanText(String text) async {
    final lower = text.toLowerCase();

    for (final word in bannedWords) {
      if (lower.contains(word)) {
        return {
          'status': 'FLAGGED',
          'action': 'Hide / Review / Possible Ban',
          'reason': 'Detected unsafe content: $word',
        };
      }
    }

    return {
      'status': 'SAFE',
      'action': 'Allow',
      'reason': 'No obvious unsafe content detected.',
    };
  }

  static Future<String> reviewText(String text) async {
    final r = await scanText(text);
    return '${r['status']}: ${r['action']} - ${r['reason']}';
  }
}
