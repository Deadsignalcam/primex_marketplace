#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_profile_account_$(date +%Y%m%d_%H%M%S).dart"

flutter pub add image_picker
flutter pub get

# Add Profile page to pages list after admin
perl -0777 -i -pe "s/admin\(\),\n\s*\];/admin(),\n      profilePage(),\n    ];/s" lib/main.dart

# Add Profile tile before Admin Access
perl -0777 -i -pe "s/dashTile\('📊', 'Admin Access'/dashTile('👤', 'My Profile', 'Add profile photo, address, phone number, email, payment method, and password reset tools.', () => go(14)),\n        dashTile('📊', 'Admin Access'/s" lib/main.dart

# Insert profilePage before futurePage
perl -0777 -i -pe "s/\n  Widget futurePage\(/\n  Widget profilePage() => futurePage(\n        'My Profile + Account Settings',\n        'Manage your identity, contact details, payment method, security, and password reset tools.',\n        [\n          card('👤', 'Profile Photo', 'Upload or update your profile picture so buyers and sellers can recognize your account.'),\n          field('Full Name'),\n          field('Email Address'),\n          field('Phone Number'),\n          field('Street Address'),\n          field('City / State / ZIP'),\n          dropdown('Buyer', ['Buyer', 'Seller', 'Realtor', 'Investor', 'Contractor', 'Service Provider', 'Admin'], (_) {}),\n          card('💳', 'Payment Method', 'Add or update card / bank payout method. Stripe connection will be wired next.'),\n          fullBtn('Add Payment Method', () => snack('Payment method setup will connect to Stripe.')),\n          card('🔐', 'Security', 'Reset password, verify email, enable stronger login protection, and protect your PrimeX account.'),\n          fullBtn('Send Password Reset Email', () => snack('Password reset email sent.')),\n          fullBtn('Save Profile', () => snack('Profile saved.')),\n        ],\n      );\n\n  Widget futurePage(/s" lib/main.dart

flutter clean
flutter pub get
flutter run -d chrome
