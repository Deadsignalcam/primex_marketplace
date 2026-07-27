class PrimeXSafetyRules {
  static const int maxPostsPerDay = 30;
  static const int banLimit = 3;

  static const List<String> blockedWords = [
    'nude',
    'nudity',
    'sexy',
    'sex',
    'escort',
    'onlyfans',
    'porn',
    'xxx',
    'hookup',
    'hook up',
    'dating',
    'date me',
    'adult services',
    'hate',
    'racist',
    'discrimination',
    'harass',
    'threat',
    'scam',
    'fraud',
    'fake listing'
  ];

  static Map<String, dynamic> scanContent({
    required String text,
    required int postsToday,
    required int userStrikes,
  }) {
    final lower = text.toLowerCase();
    final matched = blockedWords.where((w) => lower.contains(w)).toList();

    if (matched.isNotEmpty) {
      return {
        'allowed': false,
        'flagged': true,
        'status': 'blocked',
        'reason': 'PrimeX policy violation',
        'matchedWords': matched,
        'action': 'admin_review_or_remove',
      };
    }

    if (postsToday >= maxPostsPerDay) {
      return {
        'allowed': false,
        'flagged': true,
        'status': 'rate_limited',
        'reason': '30 or more posts in one day',
        'action': 'admin_review',
      };
    }

    if (userStrikes >= banLimit) {
      return {
        'allowed': false,
        'flagged': true,
        'status': 'banned',
        'reason': '3 violations reached',
        'action': 'kick_from_platform',
      };
    }

    return {
      'allowed': true,
      'flagged': false,
      'status': 'approved',
      'reason': 'Passed PrimeX AI Autopilot',
      'action': 'publish_or_send',
    };
  }
}
