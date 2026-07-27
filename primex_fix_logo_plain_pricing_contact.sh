#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_logo_plain_pages_$(date +%Y%m%d_%H%M%S).dart"

python - <<'PY'
from pathlib import Path
import re

p = Path("lib/main.dart")
s = p.read_text(encoding="utf-8")

# Replace logo painter sizes so PRIME/X no longer overlap
s = s.replace("width: 260,", "width: 230,")
s = s.replace("height: 82,", "height: 76,")
s = s.replace("fontSize: 30,", "fontSize: 24,")
s = s.replace("fontSize: 48,", "fontSize: 36,")
s = s.replace("market.paint(canvas, const Offset(16, 54));", "market.paint(canvas, const Offset(14, 47));")
s = s.replace("tagline.paint(canvas, const Offset(17, 69));", "tagline.paint(canvas, const Offset(14, 61));")
s = s.replace("canvas.drawLine(const Offset(14, 48), Offset(size.width - 72, 48), linePaint);", "canvas.drawLine(const Offset(14, 42), Offset(size.width - 64, 42), linePaint);")
s = s.replace("Rect.fromLTWH(size.width - 58, 18, 44, 44)", "Rect.fromLTWH(size.width - 48, 18, 34, 34)")
s = s.replace("ai.paint(canvas, Offset(size.width - 46, 31));", "ai.paint(canvas, Offset(size.width - 39, 28));")

# Ensure pricing/contact use plain box, not future background
s = re.sub(
    r"Widget pricing\(\) => futurePage\([\s\S]*?\n  \);",
    """Widget pricing() => pagePlain('Pricing', const Text(
    'Realtor/Broker Listing: 5 dollars / 35 days\\nVehicle Listing: 5 dollars / 35 days\\nBoost 4 Days: 7.99\\nBoost 15 Days: 14.99\\nForeclosure Lead: 9.99\\nPrimeX Pro: 49.99 per month',
    style: TextStyle(fontSize: 18, height: 1.7),
  ));""",
    s
)

s = re.sub(
    r"Widget contact\(\) => futurePage\([\s\S]*?\n  \);",
    """Widget contact() => pagePlain('Contact', const Text(
    'syntax.phantom@primexmarketplace.com\\nprimexmarketplace.com\\nPA\\n\\nPowered by Syntax Phantom @ 2026',
    style: TextStyle(fontSize: 18, height: 1.7),
  ));""",
    s
)

p.write_text(s, encoding="utf-8")
print("✅ Logo fixed. Pricing and Contact set back to plain.")
PY

flutter clean
flutter pub get
flutter build web --release

echo "✅ Done. Run: flutter run -d chrome"
