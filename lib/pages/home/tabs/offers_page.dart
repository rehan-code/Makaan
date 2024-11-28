import 'package:flutter/material.dart';
import 'package:makaan/models/offer.dart';
import 'package:makaan/widgets/offer_card.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  List<Offer> get _sampleOffers => [
    Offer(
      id: '1',
      shopName: 'Costa Coffee',
      shopImage: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      offerText: 'Buy One Get One Free on all hot drinks',
      validity: DateTime.now().add(const Duration(days: 30)),
      tags: ['Coffee', 'BOGO', 'Hot Drinks'],
      redemptionType: RedemptionType.inStore,
      storeDescription: 'Your favourite coffee shop on the high street. We take pride in serving perfectly crafted coffee using our signature Mocha Italia blend, alongside a wide range of hot drinks, sandwiches and snacks.',
      rating: 4.5,
      numberOfReviews: 328,
      offerDetails: 'Get a free hot drink when you buy any hot drink from our menu. Perfect for catching up with friends or treating a colleague.',
      termsAndConditions: [
        'Valid on all hot drinks only',
        'Free drink must be of equal or lesser value',
        'Valid 7 days a week',
        'Not valid with any other offer or discount',
        'Valid at participating UK stores only',
        'Show this offer at the till to redeem',
      ],
      location: StoreLocation(
        address: '123 Oxford Street',
        city: 'London',
        state: 'Greater London',
        zipCode: 'W1D 2JA',
        latitude: 51.5152,
        longitude: -0.1454,
      ),
      social: StoreSocial(
        instagram: 'https://instagram.com/costacoffee',
        facebook: 'https://facebook.com/costacoffee',
        website: 'https://costa.co.uk',
      ),
      reviews: [
        StoreReview(
          userName: 'James W.',
          userImage: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
          rating: 5.0,
          comment: 'Brilliant offer! Used it this morning with a colleague. The flat white was perfect as always.',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        StoreReview(
          userName: 'Emma S.',
          userImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
          rating: 4.0,
          comment: 'Great value with the BOGO offer. Staff were lovely and helpful.',
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
    ),
    Offer(
      id: '2',
      shopName: 'Nando\'s',
      shopImage: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      offerText: '20% off your total bill',
      validity: DateTime.now().add(const Duration(days: 15)),
      tags: ['Restaurant', 'Chicken', 'Discount'],
      redemptionType: RedemptionType.both,
      storeDescription: 'Home of the legendary Portuguese flame-grilled PERi-PERi chicken. From the first branch in Ealing, London in 1992 to over 450 restaurants across the UK today.',
      rating: 4.7,
      numberOfReviews: 892,
      offerDetails: 'Enjoy 20% off your total bill, including drinks and desserts. Valid for both dine-in and takeaway orders.',
      termsAndConditions: [
        'Minimum spend £15',
        'Valid for dine-in and takeaway',
        'Not valid on delivery orders',
        'Cannot be used with other promotions',
        'Valid at all UK restaurants',
        'Show this offer before ordering',
      ],
      location: StoreLocation(
        address: '10 Beak Street',
        city: 'London',
        state: 'Greater London',
        zipCode: 'W1F 9RA',
        latitude: 51.5133,
        longitude: -0.1382,
      ),
      social: StoreSocial(
        instagram: 'https://instagram.com/nandosuk',
        facebook: 'https://facebook.com/nandosuk',
        twitter: 'https://twitter.com/nandosuk',
        website: 'https://nandos.co.uk',
      ),
      reviews: [
        StoreReview(
          userName: 'Oliver P.',
          userImage: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
          rating: 5.0,
          comment: 'Can\'t beat Nando\'s! The discount makes it even better value for a family meal.',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        StoreReview(
          userName: 'Sophie H.',
          userImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
          rating: 4.5,
          comment: 'Great discount! Perfect for our work lunch outings.',
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    ),
    Offer(
      id: '3',
      shopName: 'Marks & Spencer',
      shopImage: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      offerText: '£10 off when you spend £50 on clothing',
      validity: DateTime.now().add(const Duration(days: 7)),
      tags: ['Fashion', 'Retail', 'Clothing'],
      redemptionType: RedemptionType.both,
      storeDescription: 'Your trusted British retailer since 1884. Quality clothing, homeware, and food, made with the finest materials and careful attention to detail.',
      rating: 4.6,
      numberOfReviews: 1243,
      offerDetails: 'Get £10 off your clothing purchase when you spend £50 or more. Valid across all clothing departments including menswear, womenswear, and childrenswear.',
      termsAndConditions: [
        'Minimum spend £50 on clothing',
        'Valid in-store and online',
        'Excludes sale items',
        'One voucher per transaction',
        'Valid at all UK stores',
        'Cannot be used with other offers',
      ],
      location: StoreLocation(
        address: '173 Oxford Street',
        city: 'London',
        state: 'Greater London',
        zipCode: 'W1D 2JB',
        latitude: 51.5161,
        longitude: -0.1420,
      ),
      social: StoreSocial(
        instagram: 'https://instagram.com/marksandspencer',
        facebook: 'https://facebook.com/marksandspencer',
        website: 'https://marksandspencer.com',
      ),
      reviews: [
        StoreReview(
          userName: 'Charlotte B.',
          userImage: 'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
          rating: 5.0,
          comment: 'Perfect timing for updating my autumn wardrobe! The discount made it even better.',
          date: DateTime.now().subtract(const Duration(days: 4)),
        ),
        StoreReview(
          userName: 'William M.',
          userImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
          rating: 4.0,
          comment: 'Good value when buying multiple items. The quality is always reliable at M&S.',
          date: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ],
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
