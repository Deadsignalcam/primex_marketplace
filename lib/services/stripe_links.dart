class StripeLinks {
  static const boost4Days = 'https://buy.stripe.com/cNi14nfcT7ve3Oj1wdgfU0k';
  static const boost15Days = 'https://buy.stripe.com/fZucN5c0n5n47ev4llpgfU0f';
  static const realtor35Days = 'https://buy.stripe.com/28E8wP6GceXEgB5fm3gfu08';
  static const vehicle35Days = 'https://buy.stripe.com/28E8wP6GceXEgB5fm3gfu08';
  static const foreclosureLead =
      'https://buy.stripe.com/4gMaEX3u02aSckP2zhgfu09';
  static const primeXPro = 'https://buy.stripe.com/4gMaEX3u02aSckP2zhgfu09';

  static const standardAd = 'https://buy.stripe.com/aFa5kD7Kg5n4bgLehZgfu0a';
  static const businessSpotlight =
      'https://buy.stripe.com/cNi8wPggM4j05WrehZgfu0j';
  static const homepageBanner =
      'https://buy.stripe.com/9B66oHaWseXE84zddVgfu0l';

  static String adLink(String plan) {
    final p = plan.toLowerCase();
    if (p.contains('homepage') || p.contains('banner') || p.contains('19.99')) {
      return homepageBanner;
    }
    if (p.contains('business') ||
        p.contains('spotlight') ||
        p.contains('9.99')) {
      return businessSpotlight;
    }
    return standardAd;
  }
}
