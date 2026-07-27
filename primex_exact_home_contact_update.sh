#!/usr/bin/env bash
set -e

echo "Hard updating PrimeX homepage contact..."

# Update contact footer everywhere
find lib -type f -name "*.dart" -exec sed -i \
's|Johnstown, PA, USA|PA|g; s|(814) 555-0175|primexmarketplace.com|g; s|syntax.phantom@primexmarketplace.com|syntax.phantom@primexmarketplace.com|g' {} \;

# Make sure site shows correct contact block
find lib -type f -name "*.dart" -exec sed -i \
's|CONTACT\\n\\nsyntax.phantom@primexmarketplace.com\\nprimexmarketplace.com\\nPA|CONTACT\\n\\nsyntax.phantom@primexmarketplace.com\\nprimexmarketplace.com\\nPA|g' {} \;

flutter clean
flutter pub get
flutter build web --release

echo "Updated:"
echo "Email: syntax.phantom@primexmarketplace.com"
echo "Website: primexmarketplace.com"
echo "Location: PA"
echo "Now run: flutter run -d chrome"
