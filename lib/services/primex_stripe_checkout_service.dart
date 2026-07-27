import 'package:url_launcher/url_launcher.dart';

class PrimeXStripeCheckoutService {
  static const String boost4DaysUrl =
      'https://buy.stripe.com/00w6oH1lS02K0C7gq7gfu0h';

  static const String boost15DaysUrl =
      'https://buy.stripe.com/9B628r0hOaHo0C75Ltgfu0i';

  static Future<bool> openBoost4Days() {
    return _openStripe(boost4DaysUrl);
  }

  static Future<bool> openBoost15Days() {
    return _openStripe(boost15DaysUrl);
  }

  static Future<bool> _openStripe(String checkoutUrl) async {
    final uri = Uri.parse(checkoutUrl);

    if (!await canLaunchUrl(uri)) {
      return false;
    }

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }
}
