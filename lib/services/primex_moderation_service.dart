class PrimeXModerationService {
  static final blockedWords = [
    'nude',
    'nudity',
    'porn',
    'sex',
    'escort',
    'dating',
    'hookup',
    'hate',
    'scam',
    'cashapp scam',
    'onlyfans',
  ];

  static bool isBlocked(String text) {
    final t = text.toLowerCase();
    return blockedWords.any((w) => t.contains(w));
  }

  static String warning =
      'PrimeX does not allow nudity, dating, abuse, hate, scams, or unsafe content.';
}
