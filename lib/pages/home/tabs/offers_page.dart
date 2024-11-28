import 'package:flutter/material.dart';
import 'package:makaan/models/offer.dart';
import 'package:makaan/widgets/offer_card.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  List<Offer> get _sampleOffers => [
    Offer(
      id: '1',
      shopName: 'Coffee House',
      shopImage: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      offerText: 'Get 20% off on all coffee drinks',
      validity: DateTime.now().add(const Duration(days: 30)),
      tags: ['Coffee', 'Drinks', 'Halal'],
      redemptionType: RedemptionType.inStore,
    ),
    Offer(
      id: '2',
      shopName: 'Pizza Palace',
      shopImage: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      offerText: 'Buy 1 Get 1 Free on all large pizzas',
      validity: DateTime.now().add(const Duration(days: 15)),
      tags: ['Pizza', 'Food', 'BOGO'],
      redemptionType: RedemptionType.both,
    ),
    Offer(
      id: '3',
      shopName: 'Fashion Store',
      shopImage: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      offerText: '50% off on selected items',
      validity: DateTime.now().add(const Duration(days: 7)),
      tags: ['Fashion', 'Clothing'],
      redemptionType: RedemptionType.online,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Offers'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _sampleOffers.length,
        itemBuilder: (context, index) => OfferCard(
          offer: _sampleOffers[index],
        ),
      ),
    );
  }
}
