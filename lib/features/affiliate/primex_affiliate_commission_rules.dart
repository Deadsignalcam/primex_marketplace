class PrimeXAffiliateCommissionRules {
  static const double fullDirectCommission = 12.25;
  static const double referralOverrideCommission = 2.25;
  static const double referredSellerCommission = 10.00;

  static Map<String, double> calculate({
    required bool hasReferringAffiliate,
  }) {
    if (hasReferringAffiliate) {
      return {
        'referrerEarns': referralOverrideCommission,
        'affiliateEarns': referredSellerCommission,
        'totalPayout': referralOverrideCommission + referredSellerCommission,
      };
    }

    return {
      'referrerEarns': 0.00,
      'affiliateEarns': fullDirectCommission,
      'totalPayout': fullDirectCommission,
    };
  }
}
