#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_admin_login_$(date +%Y%m%d_%H%M%S).dart"

# Add Admin Login page after profile in pages list
perl -0777 -i -pe "s/profile\(\),/profile(),\n      adminLogin(),/s" lib/main.dart

# Change Admin dashboard tile to open Admin Login instead of Admin directly
perl -0777 -i -pe "s/tile\('📊', 'Admin Access', ([\s\S]*?), \(\) => go\(13\)\)/tile('📊', 'Admin Access', \$1, () => go(15))/s" lib/main.dart

# Insert Admin Login page before admin page
perl -0777 -i -pe "s/\n  Widget admin\(\) =>/\n  Widget adminLogin() => pageBox('Admin Login', 'Restricted admin access. Only authorized PrimeX administrators can enter.', [\n        field('Admin Email'),\n        field('Admin Password'),\n        card('🔐', 'Protected Admin Area', 'Admin access controls AI moderation, user safety, revenue, analytics, security alerts, cyber protection, and platform settings.'),\n        fullBtn('Enter Admin Command Center', () => go(13)),\n      ]);\n\n  Widget admin() =>/s" lib/main.dart

flutter clean
flutter pub get
flutter run -d chrome
