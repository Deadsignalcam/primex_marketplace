import 'package:flutter/material.dart';

import '../features/listings/listings_page.dart';
import '../features/feed/live_feed_page.dart';
import '../features/jobs/jobs_services_page.dart';
import '../features/map/map_page.dart';
import '../features/chat/primex_chat_inbox_page.dart';
import '../features/leads/primex_sales_leads_page.dart';
import '../features/affiliate/primex_affiliate_center_page.dart';
import '../features/affiliate/primex_affiliate_landing_page.dart';

class PrimeXHomeCircleBubbles extends StatelessWidget {
  const PrimeXHomeCircleBubbles({super.key});

  void openPage(BuildContext context, String tab) {

    if (tab == 'Messages') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PrimeXChatInboxPage(),
        ),
      );
      return;
    }

    if (tab == 'Property') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MapPage(),
        ),
      );
      return;
    }

    if (tab == 'Affiliate') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PrimeXAffiliateLandingPage(),
        ),
      );
      return;
    }

    if (tab == 'Affiliate Center') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PrimeXAffiliateCenterPage(),
        ),
      );
      return;
    }

    if (tab == 'Listings') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ListingsPage(),
        ),
      );
      return;
    }

    if (tab == 'Feed') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LiveFeedPage(),
        ),
      );
      return;
    }

    if (tab == 'Jobs') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const JobsServicesPage(),
        ),
      );
      return;
    }

    if (tab == 'Leads') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PrimeXSalesLeadsPage(),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _bubble(context, 'Messages'),
        _bubble(context, 'Property'),
        _bubble(context, 'Listings'),
        _bubble(context, 'Feed'),
        _bubble(context, 'Jobs'),
        _bubble(context, 'Leads'),
        _bubble(context, 'Affiliate'),
        _bubble(context, 'Affiliate Center'),
      ],
    );
  }

  Widget _bubble(BuildContext context, String title) {
    return GestureDetector(
      onTap: () => openPage(context, title),
      child: Container(
        width: 90,
        height: 90,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: Colors.green),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
