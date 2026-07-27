#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_logo_categories_$(date +%Y%m%d_%H%M%S).dart"

python - <<'PY'
from pathlib import Path
import re

p = Path("lib/main.dart")
s = p.read_text(encoding="utf-8")

# Add selected category state
s = s.replace(
"int page = 0;\n\n  static const cyan",
"int page = 0;\n  String activeCategory = 'REAL ESTATE';\n\n  static const cyan"
)

# Add category page to pages list
s = s.replace(
"      profile(),\n    ];",
"      profile(),\n      categoryPage(),\n    ];"
)

# Make category boxes clickable
s = s.replace(
"children: cats.map((c) => categoryBox(c[0], c[1], c[2])).toList(),",
"children: cats.map((c) => categoryBox(c[0], c[1], c[2], () { setState(() => activeCategory = c[1]); go(15); })).toList(),"
)

# Fix pin width so COMMERCIAL does not break
s = s.replace("width: 170,", "width: 215,")
s = s.replace("fontSize: 15", "fontSize: 14")

# Replace categoryBox with clickable version
s = re.sub(
r"Widget categoryBox\(String icon, String title, String body\) => Container\([\s\S]*?\n      \);",
"""Widget categoryBox(String icon, String title, String body, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: glass(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 5),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(color: cyan, fontWeight: FontWeight.w900, fontSize: 12)),
              const SizedBox(height: 4),
              Text(body, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10, height: 1.25)),
            ],
          ),
        ),
      );""",
s,
count=1
)

# Add category page before dashboard
s = s.replace(
"  Widget dashboard() => pageBox('User Dashboard'",
"""  Widget categoryPage() => pageBox(
        activeCategory,
        'Browse $activeCategory listings. Login or sign up to message, call, save, post, or make an offer.',
        [
          card('📍', '$activeCategory Listing Map Pin', 'This category opens from the homepage and will connect to Firebase listings next.'),
          card('💬', 'Message Seller', 'Secure PrimeX messaging stays inside the platform.'),
          card('📞', 'Call Seller', 'Call button will connect to the seller phone number.'),
          fullBtn('Login To Browse $activeCategory', () => go(5)),
          fullBtn('Sign Up To Post In $activeCategory', () => go(6)),
        ],
      );

  Widget dashboard() => pageBox('User Dashboard'"""
)

# Replace logo widget with neon X design
s = re.sub(
r"class PrimeXLogo extends StatelessWidget \{[\s\S]*?\n\}",
"""class PrimeXLogo extends StatelessWidget {
  const PrimeXLogo({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 330,
        height: 86,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'PRIME',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: 'X',
                    style: TextStyle(
                      color: Color(0xFF00F5FF),
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(color: Color(0xFF00F5FF), blurRadius: 18),
                        Shadow(color: Color(0xFF006BFF), blurRadius: 34),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'M A R K E T P L A C E',
              style: TextStyle(
                color: Color(0xFF00F5FF),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.6,
              ),
            ),
            Text(
              '— BUY • SELL • CONNECT —',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
              ),
            ),
          ],
        ),
      );
}""",
s,
count=1
)

p.write_text(s, encoding="utf-8")
PY

flutter clean
flutter pub get
flutter run -d chrome
