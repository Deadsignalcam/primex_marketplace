import 'package:url_launcher/url_launcher.dart';

class PhoneService {
  static Future<void> call(String phone) async {
    if (phone.trim().isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    await launchUrl(uri);
  }

  static Future<void> sms(String phone) async {
    if (phone.trim().isEmpty) return;
    final uri = Uri.parse('sms:$phone');
    await launchUrl(uri);
  }
}
