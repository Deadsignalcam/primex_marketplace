import 'package:flutter/material.dart';
import '../auth/login_page.dart';

class PrimeXProLoginPage extends StatelessWidget {
  const PrimeXProLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage(role: 'pro');
  }
}

class ProLoginPage extends StatelessWidget {
  const ProLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage(role: 'pro');
  }
}
