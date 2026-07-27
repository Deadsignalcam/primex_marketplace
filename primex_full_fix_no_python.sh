#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_before_full_fix_$(date +%Y%m%d_%H%M%S).dart"

perl -0777 -i -pe "s/class PrimeXLogo extends StatelessWidget \{[\s\S]*?\n\}/class PrimeXLogo extends StatelessWidget {\n  const PrimeXLogo({super.key});\n\n  @override\n  Widget build(BuildContext context) => SizedBox(\n        width: 330,\n        height: 86,\n        child: Column(\n          crossAxisAlignment: CrossAxisAlignment.start,\n          mainAxisAlignment: MainAxisAlignment.center,\n          children: const [\n            Text.rich(TextSpan(children: [\n              TextSpan(text: 'PRIME', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 1.2)),\n              TextSpan(text: 'X', style: TextStyle(color: Color(0xFF00F5FF), fontSize: 50, fontWeight: FontWeight.w900, shadows: [Shadow(color: Color(0xFF00F5FF), blurRadius: 22), Shadow(color: Color(0xFF006BFF), blurRadius: 38)])),\n            ])),\n            Text('M A R K E T P L A C E', style: TextStyle(color: Color(0xFF00F5FF), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 4.4)),\n            Text('— BUY • SELL • CONNECT —', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.8)),\n          ],\n        ),\n      );\n}/s" lib/main.dart

perl -0777 -i -pe "s/width: 170,/width: 220,/g; s/'COMMERCIA\\nL'/'COMMERCIAL'/g; s/'COMMERCIA L'/'COMMERCIAL'/g; s/'COMMERCIA'/'COMMERCIAL'/g" lib/main.dart

perl -0777 -i -pe "s/Widget categoryBox\\(String icon, String title, String body\\) => Container\\(/Widget categoryBox(String icon, String title, String body) => InkWell(\\n        onTap: () => snack(title + ' category opened.'),\\n        child: Container(/s" lib/main.dart

perl -0777 -i -pe "s/\\n      \\);\\n\\n  Widget bottomFeature/\\n        ),\\n      );\\n\\n  Widget bottomFeature/s" lib/main.dart

flutter clean
flutter pub get
flutter run -d chrome
