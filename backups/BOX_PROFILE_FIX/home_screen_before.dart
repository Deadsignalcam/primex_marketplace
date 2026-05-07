import '../services/stripe_links.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class MarketPost {
  final String platform;
  final String category;
  final String title;
  final String price;
  final String country;
  final String state;
  final String county;
  final String city;
  final String userName;
  final String message;
  final double lat;
  final double lng;
  final List<String> photos;

  const MarketPost({
    required this.platform,
    required this.category,
    required this.title,
    required this.price,
    required this.country,
    required this.state,
    required this.county,
    required this.city,
    required this.userName,
    required this.message,
    required this.lat,
    required this.lng,
    this.photos = const [],
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const bg = Color(0xFF0D1623);
  static const panel = Color(0xFF111B2D);
  static const darkPanel = Color(0xFF0F1728);
  static const card = Color(0xFF1A2332);
  static const gold = Color(0xFFD7A847);

  String platform = "Tools";
  String category = "Inspection tools";
  String country = "United States";
  String state = "PA";
  String county = "Cambria";
  String city = "Johnstown";

  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final photoCtrl = TextEditingController();

  final List<String> tempPhotos = [];

  final Map<String, List<String>> categories = const {
    "Housing": [
      "Real estate for sale",
      "Foreclosures",
      "Rentals",
      "Office & commercial",
      "Rooms & shares",
      "Parking & storage",
      "Wanted: real estate",
      "Wanted: apartments"
    ],
    "Tools": [
      "Inspection tools",
      "Power tools",
      "Hand tools",
      "Ladders",
      "Generators",
      "Safety gear"
    ],
    "Vehicles": [
      "Cars & trucks",
      "Commercial trucks",
      "Trailers",
      "Motorcycles",
      "Parts",
      "Equipment"
    ],
    "Jobs": [
      "Field service",
      "Inspection work",
      "Contractor jobs",
      "Admin",
      "Gigs",
      "General labor"
    ],
    "Services": [
      "Property inspection",
      "Process server",
      "Appraisal",
      "Roof inspection",
      "Radon",
      "Public adjuster",
      "Cleaning",
      "Repairs"
    ],
    "For Sale": [
      "General items",
      "Electronics",
      "Furniture",
      "Appliances",
      "Materials",
      "Collectibles"
    ],
    "Community": [
      "Local updates",
      "Events",
      "Lost & found",
      "Recommendations",
      "Market alerts",
      "Discussions"
    ],
  };

  final List<String> countries = const [
    "United States",
    "Canada",
    "Mexico",
    "Puerto Rico"
  ];

  final List<String> states = const [
    "AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA",
    "HI","ID","IL","IN","IA","KS","KY","LA","ME","MD",
    "MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ",
    "NM","NY","NC","ND","OH","OK","OR","PA","RI","SC",
    "SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"
  ];

  final List<String> counties = const [
    "Cambria","Blair","Allegheny","Monroe","Luzerne","Philadelphia",
    "Bucks","Montgomery","Delaware","Chester","Lehigh","Northampton",
    "Essex","Hudson","Bergen","Queens","Kings","Bronx","New York",
    "Richmond","Westchester","Erie","Cuyahoga","Franklin"
  ];

  final List<String> cities = const [
    "Johnstown","Pittsburgh","Altoona","Scranton","Philadelphia",
    "Allentown","East Stroudsburg","Camden","Newark","New York",
    "Buffalo","Cleveland","Columbus","Baltimore","Washington"
  ];

  final List<MarketPost> posts = [
    const MarketPost(
      platform: "Housing",
      category: "Foreclosures",
      title: "Foreclosure Deal",
      price: "\$82,000",
      country: "United States",
      state: "PA",
      county: "Cambria",
      city: "Johnstown",
      userName: "Sarah Johnson",
      message: "Just listed a new property near downtown Johnstown.",
      lat: 40.3267,
      lng: -78.9219,
    ),
    const MarketPost(
      platform: "Housing",
      category: "Real estate for sale",
      title: "Real Estate Lead",
      price: "\$145,000",
      country: "United States",
      state: "PA",
      county: "Cambria",
      city: "Johnstown",
      userName: "Mike Williams",
      message: "Market is heating up. Prices moving fast.",
      lat: 40.3350,
      lng: -78.9140,
    ),
    const MarketPost(
      platform: "For Sale",
      category: "General items",
      title: "General Item",
      price: "\$45",
      country: "United States",
      state: "PA",
      county: "Cambria",
      city: "Johnstown",
      userName: "Jessica Lee",
      message: "Looking for a 3 bed home. Any leads?",
      lat: 40.3310,
      lng: -78.9280,
    ),
    const MarketPost(
      platform: "Tools",
      category: "Inspection tools",
      title: "Tools / Field Kit",
      price: "\$180",
      country: "United States",
      state: "PA",
      county: "Cambria",
      city: "Johnstown",
      userName: "Tools Market",
      message: "New inspection tool kit posted.",
      lat: 40.3220,
      lng: -78.9360,
    ),
    const MarketPost(
      platform: "Vehicles",
      category: "Cars & trucks",
      title: "Vehicle Listing",
      price: "\$12,500",
      country: "United States",
      state: "PA",
      county: "Cambria",
      city: "Johnstown",
      userName: "PrimeX Auto",
      message: "Vehicle lead added.",
      lat: 40.3180,
      lng: -78.9300,
    ),
    const MarketPost(
      platform: "Jobs",
      category: "Field service",
      title: "Field Service Job",
      price: "\$75",
      country: "United States",
      state: "PA",
      county: "Cambria",
      city: "Johnstown",
      userName: "PrimeX Jobs",
      message: "Field service job posted.",
      lat: 40.3420,
      lng: -78.9050,
    ),
  ];

  List<MarketPost> get filteredPosts {
    final exact = posts.where((p) => p.platform == platform && p.category == category).toList();
    if (exact.isNotEmpty) return exact;

    final byPlatform = posts.where((p) => p.platform == platform).toList();
    if (byPlatform.isNotEmpty) return byPlatform;

    return posts;
  }

  Set<gmaps.Marker> get pins {
    return filteredPosts.map((p) {
      return gmaps.Marker(
        markerId: gmaps.MarkerId("${p.platform}-${p.category}-${p.title}"),
        position: gmaps.LatLng(p.lat, p.lng),
        infoWindow: gmaps.InfoWindow(
          title: p.title,
          snippet: "${p.price} • ${p.city}, ${p.state}",
        ),
      );
    }).toSet();
  }

  void choosePlatform(String value) {
    setState(() {
      platform = value;
      category = categories[value]!.first;
    });
  }

  void addPhoto() {
    final value = photoCtrl.text.trim();
    if (value.isEmpty) return;
    setState(() {
      value.split(RegExp("[, ]+")).forEach((e){ if(e.trim().isNotEmpty) tempPhotos.add(e.trim()); });
      photoCtrl.clear();
    });
  }

  void createPost() {
    final newPost = MarketPost(
      platform: platform,
      category: category,
      title: titleCtrl.text.trim().isEmpty ? category : titleCtrl.text.trim(),
      price: priceCtrl.text.trim().isEmpty ? "\$0" : priceCtrl.text.trim(),
      country: country,
      state: state,
      county: county,
      city: city,
      userName: "PrimeX User",
      message: "New $category post in $city, $state.",
      lat: 40.3267 + (posts.length * 0.002),
      lng: -78.9219 - (posts.length * 0.002),
      photos: List<String>.from(tempPhotos),
    );

    setState(() {
      posts.insert(0, newPost);
      titleCtrl.clear();
      priceCtrl.clear();
      addressCtrl.clear();
      photoCtrl.clear();
      tempPhotos.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Post added to $platform → $category")),
    );
  }

  void openProfile(MarketPost p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: panel,
        title: Text(p.userName, style: const TextStyle(color: Colors.white)),
        content: Text(
          "${p.city}, ${p.state}\n\n${p.message}\n\nPosts: ${p.platform} / ${p.category}",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Message")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subs = categories[platform] ?? [];

    return Scaffold(
      backgroundColor: bg,
      body: Row(
        children: [
          Container(
            width: 155,
            color: panel,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("PrimeX", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text("7 Platforms in One", style: TextStyle(color: Colors.white54, fontSize: 10)),
                const SizedBox(height: 18),
                for (final p in categories.keys) _sideButton(p),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  color: const Color(0xFF151C2A),
                  child: Row(
                    children: [
                      const Text("PrimeX Marketplace Dashboard", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      _topButton("Post Item", createPost),
                      _topButton("Boost \$7.99 (4 Days)", () {}),
                      _topButton("Premium \$14.99 (15 Days)", () {}),
                    ],
                  ),
                ),

                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 340,
                        padding: const EdgeInsets.all(10),
                        color: darkPanel,
                        child: ListView(
                          children: [
                            Text(platform, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),

                            for (final sub in subs) _subButton(sub),

                            const SizedBox(height: 14),
                            const Divider(color: Colors.white12),
                            const Text("Create Post", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),

                            _drop("Country", country, countries, (v) => setState(() => country = v!)),
                            _drop("State", state, states, (v) => setState(() => state = v!)),
                            _drop("County", county, counties, (v) => setState(() => county = v!)),
                            _drop("City", city, cities, (v) => setState(() => city = v!)),

                            _field("Title", titleCtrl),
                            _field("Price / rate", priceCtrl),
                            _field("Address or nearest cross street", addressCtrl),

                            Row(
                              children: [
                                Expanded(child: _field("Photo URL", photoCtrl)),
                                const SizedBox(width: 6),
                                SizedBox(
                                  height: 38,
                                  child: ElevatedButton(
                                    onPressed: addPhoto,
                                    style: ElevatedButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black),
                                    child: const Text("+"),
                                  ),
                                ),
                              ],
                            ),

                            Text("${tempPhotos.length} photos added", style: const TextStyle(color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 8),

                            ElevatedButton(
                              onPressed: createPost,
                              style: ElevatedButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black),
                              child: const Text("Create Post"),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: gmaps.GoogleMap(
                                    initialCameraPosition: const gmaps.CameraPosition(
                                      target: gmaps.LatLng(40.3267, -78.9219),
                                      zoom: 12,
                                    ),
                                    markers: pins,
                                    mapToolbarEnabled: false,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Expanded(
                                flex: 2,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for (final p in filteredPosts) _MiniCard(p, () => openProfile(p)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        width: 285,
                        padding: const EdgeInsets.all(12),
                        color: panel,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Live Community Feed", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView(
                                children: [
                                  for (final p in posts.take(12)) _Feed(p, () => openProfile(p)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideButton(String name) {
    final active = platform == name;
    return InkWell(
      onTap: () => choosePlatform(name),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? gold : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? gold : Colors.white12),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: active ? Colors.black : Colors.white70,
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _subButton(String name) {
    final active = category == name;
    return InkWell(
      onTap: () => setState(() => category = name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF253756) : card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? gold : Colors.white10),
        ),
        child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );
  }

  static Widget _topButton(String text, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: gold, foregroundColor: Colors.black),
        child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }

  static Widget _drop(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: card,
          isExpanded: true,
          iconEnabledColor: Colors.white70,
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text("$label: $e", style: const TextStyle(color: Colors.white, fontSize: 12)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  static Widget _field(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      height: 38,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
          filled: true,
          fillColor: card,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final MarketPost post;
  final VoidCallback onTap;

  const _MiniCard(this.post, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 245,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(radius: 12, child: Text(post.userName[0])),
              const SizedBox(width: 6),
              Expanded(child: Text(post.userName, style: const TextStyle(color: Colors.white70, fontSize: 11))),
            ]),
            const SizedBox(height: 8),
            Text(post.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(post.price, style: const TextStyle(color: Color(0xFFD7A847), fontWeight: FontWeight.bold)),
            Text("${post.city}, ${post.state}", style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _Feed extends StatelessWidget {
  final MarketPost post;
  final VoidCallback onTap;

  const _Feed(this.post, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(color: const Color(0xFF1A2332), borderRadius: BorderRadius.circular(9)),
        child: Row(
          children: [
            CircleAvatar(radius: 16, child: Text(post.userName[0])),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${post.userName} • ${post.city}, ${post.state}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(post.message, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}
