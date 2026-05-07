import 'package:flutter/material.dart';

void main() {
  runApp(const RealEstateSite());
}

class RealEstateSite extends StatelessWidget {
  const RealEstateSite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Promised Land Property Holdings',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Arial'),
      home: const WebsiteHome(),
    );
  }
}

class WebsiteHome extends StatefulWidget {
  const WebsiteHome({super.key});

  @override
  State<WebsiteHome> createState() => _WebsiteHomeState();
}

class _WebsiteHomeState extends State<WebsiteHome> {
  final homeKey = GlobalKey();
  final propertiesKey = GlobalKey();
  final aboutKey = GlobalKey();
  final investorsKey = GlobalKey();
  final contactKey = GlobalKey();

  void goTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _NavBar(
              onHome: () => goTo(homeKey),
              onProperties: () => goTo(propertiesKey),
              onAbout: () => goTo(aboutKey),
              onInvestors: () => goTo(investorsKey),
              onContact: () => goTo(contactKey),
            ),

            _Section(
              key: homeKey,
              title: "PROMISED LAND PROPERTY HOLDINGS",
              subtitle: "Acquiring, improving, and developing properties that build wealth and create lasting impact.",
              button: "INQUIRE NOW",
              dark: false,
            ),

            _Section(
              key: propertiesKey,
              title: "PROPERTIES",
              subtitle: "Residential, rental, foreclosure, and redevelopment opportunities prepared for serious buyers and investors.",
              button: "VIEW PROPERTIES",
              dark: true,
            ),

            _Section(
              key: aboutKey,
              title: "ABOUT US",
              subtitle: "We focus on real estate opportunities with strong upside, clean strategy, and long-term value creation.",
              button: "LEARN MORE",
              dark: false,
            ),

            _Section(
              key: investorsKey,
              title: "INVESTORS",
              subtitle: "Partner with us on fix-and-flip, rental, land, and foreclosure opportunities designed for strong returns.",
              button: "INVESTOR CONTACT",
              dark: true,
            ),

            _Section(
              key: contactKey,
              title: "CONTACT",
              subtitle: "Ready to inquire about a property, sell a property, or partner on a deal? Reach out today.",
              button: "SEND MESSAGE",
              dark: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onProperties;
  final VoidCallback onAbout;
  final VoidCallback onInvestors;
  final VoidCallback onContact;

  const _NavBar({
    required this.onHome,
    required this.onProperties,
    required this.onAbout,
    required this.onInvestors,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 35),
      color: Colors.white,
      child: Row(
        children: [
          const Text(
            "PROMISED LAND",
            style: TextStyle(
              color: Color(0xFF1C2740),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          _nav("HOME", onHome),
          _nav("PROPERTIES", onProperties),
          _nav("ABOUT US", onAbout),
          _nav("INVESTORS", onInvestors),
          _nav("CONTACT", onContact),
          const SizedBox(width: 18),
          ElevatedButton(
            onPressed: onContact,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD3A93F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("INQUIRE NOW", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _nav(String text, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1C2740),
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: .7,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String subtitle;
  final String button;
  final bool dark;

  const _Section({
    super.key,
    required this.title,
    required this.subtitle,
    required this.button,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 70),
      color: dark ? const Color(0xFF172238) : const Color(0xFFF7F4EC),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dark ? Colors.white : const Color(0xFF1C2740),
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dark ? Colors.white70 : const Color(0xFF3D4658),
                  fontSize: 20,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 34),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD3A93F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(button, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
