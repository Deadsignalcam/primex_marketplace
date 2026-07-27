import 'package:flutter/material.dart';

import '../services/primex_boost_service.dart';

class PrimeXBoostButtons extends StatefulWidget {
  final String listingId;
  final String listingTitle;
  final bool compact;

  const PrimeXBoostButtons({
    super.key,
    required this.listingId,
    required this.listingTitle,
    this.compact = false,
  });

  @override
  State<PrimeXBoostButtons> createState() => _PrimeXBoostButtonsState();
}

class _PrimeXBoostButtonsState extends State<PrimeXBoostButtons> {
  String openingPlan = '';

  Future<void> purchase(
    PrimeXBoostPlan plan,
  ) async {
    if (openingPlan.isNotEmpty) return;

    setState(() => openingPlan = plan.id);

    try {
      await PrimeXBoostService.startCheckout(
        listingId: widget.listingId,
        listingTitle: widget.listingTitle,
        plan: plan,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stripe opened for ${plan.title}. '
            'Your existing listing will be promoted after '
            'payment confirmation.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst(
                  'Bad state: ',
                  '',
                ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => openingPlan = '');
      }
    }
  }

  Widget button(PrimeXBoostPlan plan) {
    final opening = openingPlan == plan.id;

    return OutlinedButton.icon(
      onPressed: openingPlan.isNotEmpty ? null : () => purchase(plan),
      icon: opening
          ? const SizedBox(
              width: 17,
              height: 17,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Icon(
              plan.days == 4 ? Icons.trending_up : Icons.rocket_launch,
            ),
      label: Text(
        opening ? 'Opening...' : '${plan.title} ${plan.priceLabel}',
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.cyanAccent,
        side: const BorderSide(
          color: Colors.cyanAccent,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: widget.compact ? 9 : 14,
          vertical: widget.compact ? 8 : 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listingId.trim().isEmpty) {
      return const Text(
        'Post the listing first, then choose its Boost plan.',
        style: TextStyle(color: Colors.white60),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        button(PrimeXBoostService.fourDays),
        button(PrimeXBoostService.fifteenDays),
      ],
    );
  }
}
