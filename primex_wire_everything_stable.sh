#!/usr/bin/env bash
set -e

echo "🔥 Wiring PrimeX tabs + marketplace flow..."

cp lib/main.dart "lib/main_backup_before_full_wire_$(date +%Y%m%d_%H%M%S).dart"

mkdir -p lib

cat > lib/main.dart <<'DART'
import 'package:flutter/material.dart';

void main() => runApp(const PrimeXApp());

class PrimeXApp extends StatelessWidget {
  const PrimeXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrimeX Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const PrimeXShell(),
    );
  }
}

class PrimeXShell extends StatefulWidget {
  const PrimeXShell({super.key});

  @override
  State<PrimeXShell> createState() => _PrimeXShellState();
}

class _PrimeXShellState extends State<PrimeXShell> {
  int page = 0;

  final listings = [
    {'tag':'FORECLOSURE','title':'Single Family Home','loc':'Johnstown, PA','price':'89,900 dollars'},
    {'tag':'PRE-FORECLOSURE','title':'Investment Property','loc':'Bushkill, PA','price':'74,500 dollars'},
    {'tag':'BANK OWNED','title':'Bank Owned Home','loc':'Cambria County, PA','price':'66,000 dollars'},
    {'tag':'TAX LIEN','title':'Tax Lien Certificate','loc':'Monroe County, PA','price':'15,000 dollars'},
    {'tag':'COMMERCIAL','title':'Retail Strip Center','loc':'Pittsburgh, PA','price':'499,000 dollars'},
  ];

  static const bg = Color(0xFF02040D);
  static const blue = Color(0xFF006BFF);
  static const cyan = Color(0xFF00F5FF);
  static const purple = Color(0xFF9D4DFF);

  void go(int i) => setState(() => page = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      home(),
      marketplace(),
      howItWorks(),
      about(),
      pricing(),
      contact(),
      login(),
      signup(),
      postListing(),
      messages(),
      offers(),
      admin(),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            nav(),
            pages[page],
          ],
        ),
      ),
    );
  }

  Widget nav() => Container(
    height: 92,
    padding: const EdgeInsets.symmetric(horizontal: 34),
    color: Colors.black,
    child: Row(
      children: [
        InkWell(onTap: () => go(0), child: logo()),
        const Spacer(),
        navItem('Home',0),
        navItem('Marketplace',1),
        navItem('How It Works',2),
        navItem('About Us',3),
        navItem('Pricing',4),
        navItem('Contact',5),
        const SizedBox(width: 18),
        smallBtn('Login', () => go(6), outline:true),
        const SizedBox(width: 12),
        smallBtn('Sign Up', () => go(7)),
      ],
    ),
  );

  Widget logo() => const SizedBox(
    width: 310,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(TextSpan(children: [
          TextSpan(text:'PRIME', style:TextStyle(fontSize:44,fontWeight:FontWeight.w900,color:Colors.white)),
          TextSpan(text:'X', style:TextStyle(fontSize:72,fontWeight:FontWeight.w900,color:cyan,shadows:[
            Shadow(color:cyan,blurRadius:20), Shadow(color:blue,blurRadius:35)
          ])),
        ])),
        Text('M A R K E T P L A C E', style:TextStyle(color:cyan,fontSize:12,letterSpacing:7)),
        SizedBox(height:4),
        Text('B U Y .  S E L L .  C O N N E C T .', style:TextStyle(color:Colors.white70,fontSize:10,letterSpacing:4)),
      ],
    ),
  );

  Widget navItem(String text, int i) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: InkWell(
      onTap: () => go(i),
      child: Text(text, style: TextStyle(color: page == i ? cyan : Colors.white, fontWeight: FontWeight.bold)),
    ),
  );

  Widget home() => Column(
    children: [
      hero(),
      featureBar(),
      listingsSection(),
      footer(),
    ],
  );

  Widget hero() => SizedBox(
    height: 560,
    child: Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: DigitalPainter())),
        Positioned.fill(child: Container(decoration: const BoxDecoration(
          gradient: LinearGradient(colors:[Color(0xF202040D),Color(0x7702040D),Color(0x2202040D)])
        ))),
        Positioned(left:34, top:80, width:470, child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('THE #1 MARKETPLACE FOR', style:TextStyle(fontSize:19,fontWeight:FontWeight.w800)),
            const SizedBox(height:10),
            const Text('EVERYTHING', style:TextStyle(fontSize:42,fontWeight:FontWeight.w900)),
            const Text('YOU NEED', style:TextStyle(fontSize:38,color:cyan,fontWeight:FontWeight.w900,shadows:[Shadow(color:cyan,blurRadius:18)])),
            const SizedBox(height:18),
            const Text('PrimeX Marketplace connects serious buyers and sellers for real estate, foreclosures, services, vehicles, jobs, tools, and business listings.', style:TextStyle(fontSize:16,height:1.55)),
            const SizedBox(height:26),
            Row(children:[
              smallBtn('Browse Listings →', () => go(1)),
              const SizedBox(width:14),
              smallBtn('Post a Listing +', () => go(8), outline:true),
            ]),
          ],
        )),
        Positioned(right:26, top:95, child: searchBox()),
      ],
    ),
  );

  Widget searchBox() => Container(
    width: 320,
    padding: const EdgeInsets.all(14),
    decoration: box(),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children:[
          Expanded(child: tab('FOR SALE',true)),
          Expanded(child: tab('RENTALS',false)),
          Expanded(child: tab('SERVICES',false)),
        ]),
        const SizedBox(height:10),
        input('Region / Country'),
        input('State / Province'),
        input('County'),
        input('City'),
        const SizedBox(height:8),
        fullBtn('Search PrimeX', () => go(1)),
      ],
    ),
  );

  Widget featureBar() {
    final data = [
      ['🌎','GLOBAL REACH','List globally.'],
      ['🛡','AI SAFETY','No scams, no hate, no abuse.'],
      ['✅','VERIFIED USERS','Trusted buyers and sellers.'],
      ['💰','OFFERS','Make offers with confidence.'],
      ['📄','PROOF OF FUNDS','Verify funds instantly.'],
      ['💬','MESSAGING','Built-in secure messaging.'],
      ['📞','CALL','Call directly in-app.'],
      ['📊','ANALYTICS','Track views, leads & more.'],
    ];
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: box(),
      child: Row(children:data.map((i)=>Expanded(child:Column(children:[
        Text(i[0], style:const TextStyle(fontSize:26)),
        Text(i[1], textAlign:TextAlign.center, style:const TextStyle(color:cyan,fontWeight:FontWeight.bold,fontSize:11)),
        Text(i[2], textAlign:TextAlign.center, style:const TextStyle(color:Colors.white70,fontSize:10)),
      ]))).toList()),
    );
  }

  Widget listingsSection() => Padding(
    padding: const EdgeInsets.fromLTRB(24,0,24,30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children:[
          const Text('BROWSE TOP OPPORTUNITIES', style:TextStyle(fontSize:22,fontWeight:FontWeight.w900)),
          const Spacer(),
          InkWell(onTap:()=>go(1), child:const Text('View All Listings →', style:TextStyle(color:cyan,fontWeight:FontWeight.bold))),
        ]),
        const SizedBox(height:12),
        Row(children:listings.map((x)=>Expanded(child:listingCard(x))).toList()),
      ],
    ),
  );

  Widget marketplace() => pageBox('Marketplace Listings', Column(
    children: [
      Row(children:[
        smallBtn('Post Listing +', () => go(8)),
        const SizedBox(width:12),
        smallBtn('Messages', () => go(9), outline:true),
        const SizedBox(width:12),
        smallBtn('Offers', () => go(10), outline:true),
      ]),
      const SizedBox(height:18),
      ...listings.map((x)=>listingWide(x)),
    ],
  ));

  Widget listingWide(Map x) => Container(
    margin: const EdgeInsets.only(bottom:14),
    padding: const EdgeInsets.all(14),
    decoration: box(),
    child: Row(children:[
      SizedBox(width:170,height:95,child:CustomPaint(painter:HouseCardPainter())),
      const SizedBox(width:14),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('${x['tag']} • ${x['title']}', style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
        Text('${x['loc']}  •  ${x['price']}', style:const TextStyle(color:cyan)),
      ])),
      smallBtn('View', (){}),
      const SizedBox(width:8),
      smallBtn('Message', () => go(9), outline:true),
      const SizedBox(width:8),
      smallBtn('Call', () => showSnack('Calling seller...'), outline:true),
      const SizedBox(width:8),
      smallBtn('Offer', () => go(10)),
      const SizedBox(width:8),
      smallBtn('Save', () => showSnack('Saved listing.'), outline:true),
    ]),
  );

  Widget listingCard(Map x) => Container(
    margin: const EdgeInsets.only(right:12),
    decoration: box(),
    child: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Stack(children:[
        SizedBox(height:120,width:double.infinity,child:CustomPaint(painter:HouseCardPainter())),
        Positioned(top:8,left:8,child:Container(
          padding:const EdgeInsets.symmetric(horizontal:8,vertical:5),
          decoration:BoxDecoration(color:blue,borderRadius:BorderRadius.circular(6)),
          child:Text('${x['tag']}', style:const TextStyle(fontSize:10,fontWeight:FontWeight.bold)),
        )),
      ]),
      Padding(padding:const EdgeInsets.all(10),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('${x['title']}', style:const TextStyle(fontWeight:FontWeight.bold)),
        Text('📍 ${x['loc']}', style:const TextStyle(color:Colors.white70,fontSize:12)),
        const SizedBox(height:6),
        Text('${x['price']}', style:const TextStyle(color:cyan,fontWeight:FontWeight.bold,fontSize:16)),
      ])),
    ]),
  );

  Widget postListing() => pageBox('Post a Listing', Column(children:[
    input('Listing Title'),
    input('Category: Real Estate / Vehicles / Services / Jobs / Tools'),
    input('Price'),
    input('Location'),
    input('Description'),
    input('Upload Photos / Video'),
    fullBtn('Publish Listing', () { listings.add({'tag':'NEW','title':'New Listing','loc':'PA','price':'0 dollars'}); showSnack('Listing published.'); go(1); }),
  ]));

  Widget messages() => pageBox('Messages', Column(children:[
    input('Search conversations'),
    messageTile('Buyer', 'Is this property still available?'),
    messageTile('Seller', 'Yes, it is still available.'),
    input('Type a message...'),
    fullBtn('Send Message', () => showSnack('Message sent.')),
  ]));

  Widget offers() => pageBox('Make Offer + Proof of Funds', Column(children:[
    input('Offer Amount'),
    input('Financing Type: Cash / FHA / VA / Hard Money / Seller Financing'),
    input('Upload Proof of Funds PDF / JPG / PNG'),
    input('Message to Seller'),
    fullBtn('Submit Verified Offer', () => showSnack('Offer submitted with proof of funds.')),
  ]));

  Widget login() => pageBox('Login', Column(children:[
    input('Email'),
    input('Password'),
    fullBtn('Login', () => showSnack('Login wired placeholder. Firebase next.')),
  ]));

  Widget signup() => pageBox('Sign Up', Column(children:[
    input('Full Name'),
    input('Email'),
    input('Phone'),
    input('Password'),
    input('Account Type: Buyer / Seller / Realtor / Investor / Contractor'),
    fullBtn('Create Account', () => showSnack('Account created placeholder. Firebase next.')),
  ]));

  Widget pricing() => pageBox('Pricing', const Text(
    'Realtor/Broker Listing: 5 dollars / 35 days\nVehicle Listing: 5 dollars / 35 days\nBoost 4 Days: 7.99\nBoost 15 Days: 14.99\nForeclosure Lead: 9.99\nPrimeX Pro: 49.99 per month',
    style: TextStyle(fontSize:18,height:1.7),
  ));

  Widget howItWorks() => pageBox('How It Works', const Text(
    'Post listings, browse opportunities, message sellers, call directly, make offers, upload proof of funds, and stay protected by PrimeX AI Autopilot.',
    style: TextStyle(fontSize:18,height:1.7),
  ));

  Widget about() => pageBox('About PrimeX', const Text(
    'PrimeX Marketplace is a professional platform for real estate, foreclosures, vehicles, services, jobs, tools, business listings, investors, and verified marketplace connections.',
    style: TextStyle(fontSize:18,height:1.7),
  ));

  Widget contact() => pageBox('Contact', const Text(
    'syntax.phantom@primexmarketplace.com\nprimexmarketplace.com\nPA\n\nPowered by Syntax Phantom @ 2026',
    style: TextStyle(fontSize:18,height:1.7),
  ));

  Widget admin() => pageBox('Admin Safety Center', const Text(
    'AI Autopilot Rules:\nNo dating. No nudity. No scams. No hate. No abuse. No fraud. 30+ posts daily gets flagged. 3 strikes can remove a user.',
    style: TextStyle(fontSize:18,height:1.7),
  ));

  Widget pageBox(String title, Widget child) => Padding(
    padding: const EdgeInsets.all(28),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: box(),
      child: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(title, style:const TextStyle(color:cyan,fontSize:28,fontWeight:FontWeight.w900)),
        const SizedBox(height:18),
        child,
      ]),
    ),
  );

  Widget messageTile(String who, String msg) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom:10),
    padding: const EdgeInsets.all(14),
    decoration: box(),
    child: Text('$who: $msg'),
  );

  Widget footer() => Container(
    padding: const EdgeInsets.all(24),
    color: Colors.black,
    child: const Text('PrimeX Marketplace — Buy. Sell. Connect.  |  Powered by Syntax Phantom @ 2026', style:TextStyle(color:cyan)),
  );

  Widget input(String text) => Container(
    margin: const EdgeInsets.only(bottom:12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color:Colors.black.withOpacity(.65),borderRadius:BorderRadius.circular(8),border:Border.all(color:cyan.withOpacity(.35))),
    child: Row(children:[Text(text), const Spacer(), const Text('⌄')]),
  );

  Widget tab(String t, bool active) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color:active?blue:Colors.black.withOpacity(.45),borderRadius:BorderRadius.circular(8)),
    child: Center(child:Text(t, style:const TextStyle(fontSize:11,fontWeight:FontWeight.bold))),
  );

  Widget smallBtn(String text, VoidCallback onTap, {bool outline=false}) => InkWell(
    onTap:onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal:18,vertical:11),
      decoration: BoxDecoration(color:outline?Colors.black.withOpacity(.4):blue,border:Border.all(color:blue),borderRadius:BorderRadius.circular(8),boxShadow:outline?[]:[BoxShadow(color:blue.withOpacity(.65),blurRadius:12)]),
      child: Text(text, style:const TextStyle(fontWeight:FontWeight.bold)),
    ),
  );

  Widget fullBtn(String text, VoidCallback onTap) => InkWell(
    onTap:onTap,
    child: Container(
      width:double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color:blue,borderRadius:BorderRadius.circular(8)),
      child: Center(child:Text(text, style:const TextStyle(fontWeight:FontWeight.bold,fontSize:15))),
    ),
  );

  BoxDecoration box() => BoxDecoration(
    color: const Color(0xCC050B18),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: blue.withOpacity(.85)),
    boxShadow: [BoxShadow(color: blue.withOpacity(.32), blurRadius: 18)],
  );

  void showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class DigitalPainter extends CustomPainter {
  static const cyan = Color(0xFF00F5FF);
  static const purple = Color(0xFF9D4DFF);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height), Paint()..shader=const LinearGradient(colors:[Colors.black,Color(0xFF08256B),Colors.black]).createShader(Rect.fromLTWH(0,0,size.width,size.height)));

    for (int i=0;i<160;i++) {
      canvas.drawCircle(Offset(((i*79)%size.width).toDouble(),((i*43)%size.height).toDouble()), i%5==0?1.8:.8, Paint()..color=cyan.withOpacity(.7));
    }

    void label(String t,String s,double x,double y){
      final r=RRect.fromRectAndRadius(Rect.fromLTWH(x,y,190,54), const Radius.circular(10));
      canvas.drawRRect(r, Paint()..color=Colors.black.withOpacity(.55));
      canvas.drawRRect(r, Paint()..color=cyan..style=PaintingStyle.stroke..strokeWidth=1.2);
      final tp=TextPainter(text:TextSpan(text:'$t\n',style:const TextStyle(color:cyan,fontSize:13,fontWeight:FontWeight.bold),children:[TextSpan(text:s,style:const TextStyle(color:Colors.white,fontSize:10))]),textDirection:TextDirection.ltr)..layout(maxWidth:170);
      tp.paint(canvas, Offset(x+12,y+8));
    }

    label('REAL ESTATE','Buy • Sell • Invest', size.width*.25, size.height*.18);
    label('FORECLOSURES','Hot Deals Daily', size.width*.26, size.height*.34);
    label('COMMERCIAL','Offices • Retail • Land', size.width*.27, size.height*.50);
    label('VEHICLES','Cars • Trucks • RVs', size.width*.68, size.height*.18);
    label('SERVICES','Local Professionals', size.width*.69, size.height*.34);
    label('TOOLS & JOBS','Post • Hire • Sell', size.width*.70, size.height*.50);

    final base=size.height*.88;
    final start=size.width*.34;
    final end=size.width*.76;
    final hs=[90,160,120,240,180,310,220,360,170,290,230,380,190,330,150,270,210,350];
    final bw=(end-start)/hs.length;
    for(int i=0;i<hs.length;i++){
      final h=hs[i].toDouble(), x=start+i*bw, top=base-h, c=i.isEven?cyan:purple;
      final rect=Rect.fromLTWH(x+3,top,bw-6,h);
      canvas.drawRect(rect, Paint()..color=Colors.black.withOpacity(.78));
      canvas.drawRect(rect, Paint()..color=c..style=PaintingStyle.stroke..strokeWidth=1.6);
      for(double y=top+18;y<base-8;y+=18){
        canvas.drawRect(Rect.fromLTWH(x+10,y,bw-20,3), Paint()..color=c.withOpacity(.85));
      }
    }
    canvas.drawLine(Offset(0,base),Offset(size.width,base),Paint()..color=cyan..strokeWidth=3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class HouseCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height), Paint()..shader=const LinearGradient(colors:[Color(0xFF073B7A),Colors.black]).createShader(Rect.fromLTWH(0,0,size.width,size.height)));
    final glow=Paint()..color=const Color(0xFF00F5FF)..style=PaintingStyle.stroke..strokeWidth=2;
    final fill=Paint()..color=Colors.black.withOpacity(.6);
    final base=Rect.fromLTWH(size.width*.12,size.height*.50,size.width*.76,size.height*.32);
    final roof=Path()..moveTo(size.width*.08,size.height*.50)..lineTo(size.width*.50,size.height*.20)..lineTo(size.width*.92,size.height*.50)..close();
    canvas.drawRect(base,fill); canvas.drawPath(roof,fill); canvas.drawRect(base,glow); canvas.drawPath(roof,glow);
    for(int i=0;i<4;i++){canvas.drawRect(Rect.fromLTWH(size.width*(.22+i*.15),size.height*.58,25,18),Paint()..color=const Color(0xFFFFD36B));}
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
DART

flutter clean
flutter pub get
flutter build web --release

echo "✅ PrimeX tabs and core flows are wired."
echo "Run: flutter run -d chrome"
