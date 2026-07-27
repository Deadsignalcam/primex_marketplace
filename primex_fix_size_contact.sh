#!/usr/bin/env bash
set -e

echo "Fixing PrimeX size, spacing, and contact..."

cp lib/main.dart "lib/main_backup_size_fix_$(date +%Y%m%d_%H%M%S).dart"

# Fix footer contact info
find lib -type f -name "*.dart" -exec sed -i \
's|Johnstown, PA, USA|PA|g; s|(814) 555-0175|primexmarketplace.com|g' {} \;

# Shrink oversized homepage text/cards/buttons globally
find lib -type f -name "*.dart" -exec sed -i \
's/fontSize: 52/fontSize: 36/g;
s/fontSize: 48/fontSize: 34/g;
s/fontSize: 44/fontSize: 34/g;
s/fontSize: 40/fontSize: 30/g;
s/fontSize: 34/fontSize: 26/g;
s/fontSize: 30/fontSize: 22/g;
s/fontSize: 28/fontSize: 20/g;
s/fontSize: 25/fontSize: 20/g;
s/fontSize: 24/fontSize: 18/g;
s/fontSize: 22/fontSize: 16/g;
s/fontSize: 21/fontSize: 16/g;
s/fontSize: 20/fontSize: 16/g;
s/fontSize: 19/fontSize: 15/g;
s/fontSize: 18/fontSize: 14/g;
s/fontSize: 17/fontSize: 13/g;
s/fontSize: 16/fontSize: 13/g;
s/height: 360/height: 300/g;
s/width: 460/width: 390/g;
s/height: 130/height: 105/g;
s/EdgeInsets.all(40)/EdgeInsets.all(24)/g;
s/EdgeInsets.all(34)/EdgeInsets.all(24)/g;
s/EdgeInsets.all(28)/EdgeInsets.all(20)/g;
s/EdgeInsets.all(24)/EdgeInsets.all(18)/g;
s/EdgeInsets.all(22)/EdgeInsets.all(16)/g;
s/EdgeInsets.all(20)/EdgeInsets.all(14)/g;
s/EdgeInsets.all(18)/EdgeInsets.all(14)/g;
s/EdgeInsets.all(16)/EdgeInsets.all(12)/g;
s/EdgeInsets.all(15)/EdgeInsets.all(12)/g;
s/EdgeInsets.all(14)/EdgeInsets.all(10)/g;
s/vertical: 14/vertical: 10/g;
s/horizontal: 24/horizontal: 18/g;
s/horizontal: 40/horizontal: 28/g;
s/height: 82/height: 70/g;
s/blurRadius: 22/blurRadius: 12/g;
s/blurRadius: 18/blurRadius: 10/g;
s/blurRadius: 14/blurRadius: 8/g' {} \;

flutter clean
flutter pub get
flutter build web --release

echo "Done. Now run:"
echo "flutter run -d chrome"
