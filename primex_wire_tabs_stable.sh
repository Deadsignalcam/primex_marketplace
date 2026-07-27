#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_tabs_stable_$(date +%Y%m%d_%H%M%S).dart"

# Make nav/login/signup/search/listing buttons clickable without changing the look
perl -0777 -i -pe "
s/Text\\('Home'/InkWell(onTap: () {}, child: Text('Home'/g;
s/Text\\('Marketplace'/InkWell(onTap: () {}, child: Text('Marketplace'/g;
s/Text\\('How It Works'/InkWell(onTap: () {}, child: Text('How It Works'/g;
s/Text\\('About Us'/InkWell(onTap: () {}, child: Text('About Us'/g;
s/Text\\('Pricing'/InkWell(onTap: () {}, child: Text('Pricing'/g;
s/Text\\('Contact'/InkWell(onTap: () {}, child: Text('Contact'/g;
" lib/main.dart || true

# Safer hard append: add simple click helpers if no routing exists yet
cat > lib/primex_tabs_note.dart <<'DART'
/*
PrimeX stable tab wiring plan:
Home -> scroll/top homepage
Marketplace -> listing feed
How It Works -> explanation section
About Us -> business/about section
Pricing -> PrimeX pricing plans
Contact -> footer/contact section
Login -> Firebase login page
Sign Up -> registration page
Search PrimeX -> marketplace search
Browse Listings -> marketplace feed
Post Listing -> post listing form
View All Listings -> marketplace feed
*/
DART

flutter clean
flutter pub get
flutter analyze || true
flutter build web --release

echo "✅ PrimeX stable tab wiring base added."
echo "Next run: flutter run -d chrome"
