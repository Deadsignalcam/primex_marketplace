class SafetyService {
  static const List<String> bannedWords = [
    "dating",
    "hookup",
    "sex",
    "sexual",
    "nudes",
    "escort",
    "adult",
  ];

  static bool violatesPolicy(String text) {
    final lower = text.toLowerCase();
    return bannedWords.any((word) => lower.contains(word));
  }

  static String policyMessage = '''
PrimeX Safety Policy

This platform is for business marketplace use only.

Not allowed:
- Dating or romantic use
- Sexual content or sexual requests
- Discrimination or harassment
- Threats, scams, fake accounts, or illegal activity

Violations may result in:
- Meeting ended
- Account suspended
- Future account creation blocked using verified identity and payment profile
''';
}
