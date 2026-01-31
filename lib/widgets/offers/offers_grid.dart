import 'package:flutter/material.dart';
import 'package:skool/models/offer_model.dart';
import 'package:skool/widgets/offers/offer_card.dart';

/// A grid widget displaying offer cards.
class OffersGrid extends StatelessWidget {
  final List<OfferModel> offers;
  final OfferModel? recommendedOffer;
  final void Function(OfferModel offer)? onSubscribeTap;

  const OffersGrid({
    super.key,
    required this.offers,
    this.recommendedOffer,
    this.onSubscribeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: offers.map((offer) {
        final isRecommended = recommendedOffer?.id == offer.id;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: OfferCard(
              offer: offer,
              isRecommended: isRecommended,
              onSubscribeTap: onSubscribeTap != null
                  ? () => onSubscribeTap!(offer)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
