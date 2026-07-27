import 'package:flutter/material.dart';
import 'login_page.dart';

class AuthPage extends LoginPage {
  const AuthPage({super.key}) : super(role: 'member');
}

class PrimeXLoginBrandHeader extends StatelessWidget {
  const PrimeXLoginBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        const PrimeXLoginBrandHeader(),
        SizedBox(height: 12),
        Text(
          'PRIME X',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 42,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
          ),
        ),
        Text(
          'MARKETPLACE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 23,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.8,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Buy • Sell • Connect • Grow',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: .6,
          ),
        ),
        SizedBox(height: 14),
      ],
    );
  }
}
