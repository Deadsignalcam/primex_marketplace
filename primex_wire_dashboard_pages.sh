#!/usr/bin/env bash
set -e

cp lib/main.dart "lib/main_backup_wire_dashboard_pages_$(date +%Y%m%d_%H%M%S).dart"

perl -0777 -i -pe "s/marketplace\(\),\n\s*\];/marketplace(),\n      mapPage(),\n      postListing(),\n      messages(),\n      offers(),\n      admin(),\n    ];/s" lib/main.dart

perl -0777 -i -pe "s/dashTile\('🗺', 'Map', 'View category pins\. PrimeX Pro unlocks foreclosure and tax-sale lead details\.', \(\) \{\}\)/dashTile('🗺', 'Map', 'View category pins. PrimeX Pro unlocks foreclosure and tax-sale lead details.', () => go(9))/g" lib/main.dart

perl -0777 -i -pe "s/dashTile\('➕', 'Post a Listing', 'Create posts for real estate, rentals, vehicles, services, jobs, tools, and business opportunities\.', \(\) \{\}\)/dashTile('➕', 'Post a Listing', 'Create posts for real estate, rentals, vehicles, services, jobs, tools, and business opportunities.', () => go(10))/g" lib/main.dart

perl -0777 -i -pe "s/dashTile\('💬', 'Messages', 'Secure buyer and seller messaging inside PrimeX\.', \(\) \{\}\)/dashTile('💬', 'Messages', 'Secure buyer and seller messaging inside PrimeX.', () => go(11))/g" lib/main.dart

perl -0777 -i -pe "s/dashTile\('💰', 'Offers \+ Proof of Funds', 'Submit serious offers and upload proof of funds\.', \(\) \{\}\)/dashTile('💰', 'Offers + Proof of Funds', 'Submit serious offers and upload proof of funds.', () => go(12))/g" lib/main.dart

perl -0777 -i -pe "s/dashTile\('📊', 'Admin Access', 'Admin-only moderation, AI alerts, analytics, revenue, and security tools\.', \(\) \{\}\)/dashTile('📊', 'Admin Access', 'Admin-only moderation, AI alerts, analytics, revenue, and security tools.', () => go(13))/g" lib/main.dart

perl -0777 -i -pe "s/smallBtn\('Message', \(\) \{\}, outline: true\)/smallBtn('Message', () => go(11), outline: true)/g" lib/main.dart
perl -0777 -i -pe "s/smallBtn\('Offer', \(\) \{\}\)/smallBtn('Offer', () => go(12))/g" lib/main.dart
perl -0777 -i -pe "s/smallBtn\('Call', \(\) \{\}, outline: true\)/smallBtn('Call', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calling seller...'))), outline: true)/g" lib/main.dart

perl -0777 -i -pe "s/\n  Widget futurePage\(/\n  Widget mapPage() => futurePage(\n        'PrimeX Map',\n        'Map pins show listings by category. Premium foreclosure and tax-sale details unlock with PrimeX Pro.',\n        [\n          card('🔵', 'Real Estate Pin', 'Single Family Home • Johnstown, PA • 89,900 dollars'),\n          card('🟡', 'Foreclosure Pin', 'PrimeX Pro foreclosure lead • Cambria County, PA'),\n          card('🟢', 'Service Pin', 'Property Field Inspector • Pennsylvania'),\n          card('🟠', 'Job Pin', 'Photo Runner Job • Johnstown, PA'),\n        ],\n      );\n\n  Widget postListing() => futurePage(\n        'Post a Listing',\n        'Create a listing for real estate, rentals, vehicles, services, jobs, tools, or business opportunities.',\n        [\n          field('Listing Title'),\n          field('Category'),\n          field('Price or Rate'),\n          field('Country / State / County / City'),\n          field('Description'),\n          field('Upload Photos / Video'),\n          fullBtn('Publish Listing For Review', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing submitted for review.')))),\n        ],\n      );\n\n  Widget messages() => futurePage(\n        'PrimeX Messages',\n        'Secure buyer and seller messaging stays inside PrimeX.',\n        [\n          card('🛡', 'System', 'Keep conversations inside PrimeX for safety.'),\n          card('👤', 'Buyer', 'Is this listing still available?'),\n          card('🏠', 'Seller', 'Yes. You can message, call, save, or make an offer.'),\n          field('Type your message here'),\n          fullBtn('Send Message', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message sent.')))),\n        ],\n      );\n\n  Widget offers() => futurePage(\n        'Offers + Proof of Funds',\n        'Submit serious offers with financing details and proof of funds.',\n        [\n          field('Offer Amount'),\n          field('Financing Type: Cash / FHA / VA / Hard Money / Seller Financing'),\n          field('Buyer Type: Investor / Realtor / Owner Occupant'),\n          field('Upload Proof of Funds PDF / JPG / PNG'),\n          field('Message To Seller'),\n          fullBtn('Submit Verified Offer', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Offer submitted with proof of funds.')))),\n        ],\n      );\n\n  Widget admin() => futurePage(\n        'Admin Command Center',\n        'Admin-only controls for AI safety, moderation, revenue, security, users, and analytics.',\n        [\n          card('🤖', 'AI Autopilot', 'Flags scams, harassment, discrimination, nudity, sexual solicitation, fraud, spam, fake listings, bots, and suspicious behavior.'),\n          card('🔐', 'Cyber Security Shield', 'Monitors suspicious logins, account takeover attempts, identity theft patterns, bot activity, and platform abuse.'),\n          card('📊', 'Revenue Analytics', 'Track listing fees, boosts, PrimeX Pro, foreclosure leads, tax-sale leads, and active users.'),\n          card('🚫', 'Moderation Tools', 'Warn users, remove listings, suspend accounts, ban repeat offenders, and review flagged activity.'),\n        ],\n      );\n\n  Widget futurePage(/s" lib/main.dart

flutter clean
flutter pub get
flutter build web --release

echo "✅ Dashboard buttons wired. Run: flutter run -d chrome"
