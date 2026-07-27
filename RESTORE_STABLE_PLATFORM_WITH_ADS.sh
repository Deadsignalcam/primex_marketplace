#!/usr/bin/env bash
set -e

cd ~/primex_marketplace

cp lib/main.dart lib/main_before_restore_stable_$(date +%Y%m%d_%H%M%S).dart

# restore from your stable backup if it exists
if [ -f lib/main_before_ADS_FORM_HARDWIRE_ONLY.dart ]; then
  cp lib/main_before_ADS_FORM_HARDWIRE_ONLY.dart lib/main.dart
fi

flutter clean
rm -rf build .dart_tool
flutter pub get
flutter build web --pwa-strategy=none
firebase deploy --only hosting
