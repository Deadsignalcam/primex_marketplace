#!/usr/bin/env bash
set -e

echo "🔥 Wiring real PrimeX digital marketplace background..."

cp lib/main.dart "lib/main_backup_real_digital_bg_$(date +%Y%m%d_%H%M%S).dart"
cp pubspec.yaml "pubspec_backup_real_digital_bg_$(date +%Y%m%d_%H%M%S).yaml"

mkdir -p assets/images

cat > assets/images/primex_digital_marketplace_bg.svg <<'SVG'
<svg width="1920" height="760" viewBox="0 0 1920 760" xmlns="http://www.w3.org/2000/svg">
<defs>
<radialGradient id="bg" cx="55%" cy="45%" r="80%">
<stop offset="0%" stop-color="#073b9a"/>
<stop offset="45%" stop-color="#020617"/>
<stop offset="100%" stop-color="#000000"/>
</radialGradient>
<filter id="glow"><feGaussianBlur stdDeviation="5" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
</defs>
<rect width="1920" height="760" fill="url(#bg)"/>
<g opacity=".55" stroke="#00eaff" fill="none" filter="url(#glow)">
<path d="M520 120 C720 40 920 210 1130 90 C1320 10 1500 120 1680 60"/>
<path d="M560 180 C760 100 920 250 1180 150 C1340 90 1520 190 1750 130"/>
<circle cx="690" cy="110" r="9"/><circle cx="930" cy="170" r="9"/><circle cx="1160" cy="100" r="9"/><circle cx="1410" cy="135" r="9"/><circle cx="1580" cy="90" r="9"/>
</g>

<g filter="url(#glow)">
<text x="760" y="95" fill="#00eaff" font-size="34" font-family="Arial" font-weight="700">GLOBAL MARKETPLACE NETWORK</text>
</g>

<g transform="translate(470,255)" filter="url(#glow)">
<rect x="0" y="120" width="48" height="180" fill="#030712" stroke="#00eaff"/><rect x="65" y="70" width="58" height="230" fill="#030712" stroke="#7c3cff"/><rect x="145" y="20" width="70" height="280" fill="#030712" stroke="#00eaff"/><rect x="240" y="100" width="55" height="200" fill="#030712" stroke="#7c3cff"/><rect x="320" y="0" width="78" height="300" fill="#030712" stroke="#00eaff"/><rect x="420" y="60" width="60" height="240" fill="#030712" stroke="#7c3cff"/><rect x="505" y="-25" width="90" height="325" fill="#030712" stroke="#00eaff"/><rect x="620" y="55" width="62" height="245" fill="#030712" stroke="#7c3cff"/><rect x="705" y="10" width="75" height="290" fill="#030712" stroke="#00eaff"/>
<g stroke-width="4">
<path d="M18 145 h18 M18 170 h18 M18 195 h18 M18 220 h18 M18 245 h18" stroke="#00eaff"/>
<path d="M82 95 h25 M82 125 h25 M82 155 h25 M82 185 h25 M82 215 h25" stroke="#7c3cff"/>
<path d="M165 55 h30 M165 90 h30 M165 125 h30 M165 160 h30 M165 195 h30" stroke="#00eaff"/>
<path d="M340 40 h35 M340 80 h35 M340 120 h35 M340 160 h35 M340 200 h35" stroke="#00eaff"/>
<path d="M530 10 h38 M530 55 h38 M530 100 h38 M530 145 h38 M530 190 h38" stroke="#00eaff"/>
</g>
</g>

<g filter="url(#glow)" font-family="Arial" font-size="18">
<rect x="400" y="205" width="230" height="70" rx="12" fill="#020617cc" stroke="#00eaff"/><text x="425" y="235" fill="#00eaff" font-weight="700">REAL ESTATE</text><text x="425" y="260" fill="white">Buy • Sell • Invest</text>
<rect x="390" y="310" width="230" height="70" rx="12" fill="#020617cc" stroke="#00eaff"/><text x="415" y="340" fill="#00eaff" font-weight="700">FORECLOSURES</text><text x="415" y="365" fill="white">Hot Deals Daily</text>
<rect x="1300" y="195" width="230" height="70" rx="12" fill="#020617cc" stroke="#00eaff"/><text x="1325" y="225" fill="#00eaff" font-weight="700">VEHICLES</text><text x="1325" y="250" fill="white">Cars • Trucks • RVs</text>
<rect x="1320" y="305" width="230" height="70" rx="12" fill="#020617cc" stroke="#00eaff"/><text x="1345" y="335" fill="#00eaff" font-weight="700">SERVICES</text><text x="1345" y="360" fill="white">Local Professionals</text>
<rect x="1320" y="415" width="230" height="70" rx="12" fill="#020617cc" stroke="#00eaff"/><text x="1345" y="445" fill="#00eaff" font-weight="700">TOOLS & JOBS</text><text x="1345" y="470" fill="white">Post • Hire • Sell</text>
</g>

<g filter="url(#glow)">
<text x="920" y="620" fill="#00eaff" font-size="100" font-family="Arial" font-weight="900">X</text>
<line x1="0" y1="610" x2="1920" y2="610" stroke="#00eaff" stroke-width="3"/>
</g>
</svg>
SVG

# Add flutter_svg dependency
grep -q "flutter_svg:" pubspec.yaml || sed -i '/dependencies:/a\  flutter_svg: ^2.0.10+1' pubspec.yaml

# Add assets cleanly if not present
grep -q "assets/images/" pubspec.yaml || cat >> pubspec.yaml <<'YAML'

flutter:
  assets:
    - assets/images/
YAML

# Add import and replace background
python - <<'PY'
from pathlib import Path
p = Path("lib/main.dart")
s = p.read_text()

if "package:flutter_svg/flutter_svg.dart" not in s:
    s = s.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:flutter_svg/flutter_svg.dart';")

s = s.replace("Positioned.fill(child: PrimeXDigitalWorldBackground()),", """Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/primex_digital_marketplace_bg.svg',
                fit: BoxFit.cover,
              ),
            ),""")

s = s.replace("Positioned.fill(child: DigitalCityBackground()),", """Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/primex_digital_marketplace_bg.svg',
                fit: BoxFit.cover,
              ),
            ),""")

s = s.replace("Positioned.fill(child: _digitalCity()),", """Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/primex_digital_marketplace_bg.svg',
                fit: BoxFit.cover,
              ),
            ),""")

# remove yellow stripe artifact text/color if present
s = s.replace("Color(0xFFFFD36B)", "Color(0xFF00F5FF)")

p.write_text(s)
PY

flutter clean
flutter pub get
flutter build web --release

echo "✅ Real digital marketplace background is now wired."
echo "Run: flutter run -d chrome --web-renderer canvaskit"
