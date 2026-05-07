import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const PrimeXApp());
}

class PrimeXApp extends StatelessWidget {
  const PrimeXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrimeX Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const PrimeXScaledShell(),
    );
  }
}

class PrimeXScaledShell extends StatelessWidget {
  const PrimeXScaledShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: LayoutBuilder(
        builder: (context, box) {
          return Center(
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: SizedBox(
                width: 1500,
                height: 920,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(0.78),
                  ),
                  child: const DashboardScreen(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
