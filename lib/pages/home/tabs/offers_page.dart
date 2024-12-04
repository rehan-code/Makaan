import 'package:flutter/material.dart';
import 'package:makaan/models/offer.dart';
import 'package:makaan/widgets/offer_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<Offer> _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      // Get all coupons assigned to the user
      final response = await Supabase.instance.client
          .from('coupon_assignments')
          .select('''
            id,
            is_revealed,
            revealed_at,
            created_at,
            coupon:coupons (
              id,
              title,
              description,
              terms_and_conditions,
              code,
              valid_until,
              business_id,
              business:business_details (
                business_name,
                description,
                tags,
                is_halal,
                is_halal_certified,
                location,
                social_links
              )
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        _offers = (response as List).map((data) {
          final coupon = data['coupon'];
          print('coupon: $coupon');
          final business = coupon['business'];
          print('business: $business');
          
          return Offer(
            id: coupon['id'],
            shopName: business['business_name'],
            shopImage: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80', // TODO: Add business image
            offerText: coupon['title'],
            validity: DateTime.parse(coupon['valid_until']),
            tags: List<String>.from(business['tags'] ?? []),
            redemptionType: RedemptionType.inStore, // TODO: Add redemption type to coupons
            storeDescription: business['description'],
            rating: 4.5, // TODO: Add ratings system
            numberOfReviews: 0, // TODO: Add reviews system
            offerDetails: coupon['description'],
            termsAndConditions: coupon['terms_and_conditions'].split('\n'),
            location: StoreLocation(
              address: business['location'] ?? '',
              city: '',
              state: '',
              zipCode: '',
              latitude: 0.0,
              longitude: 0.0,
            ),
            social: StoreSocial(
              instagram: business['social_links']?.firstWhere(
                (link) => link['platform'] == 'instagram', 
                orElse: () => {'url': ''})['url'] ?? '',
              facebook: business['social_links']?.firstWhere(
                (link) => link['platform'] == 'facebook', 
                orElse: () => {'url': ''})['url'] ?? '',
              website: business['social_links']?.firstWhere(
                (link) => link['platform'] == 'website', 
                orElse: () => {'url': ''})['url'] ?? '',
            ),
            reviews: [], // TODO: Add reviews system
          );
        }).toList();

        print(_offers);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
        print(e);
      
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading offers: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No offers available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new offers',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Offers'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _offers.length,
        itemBuilder: (context, index) => OfferCard(
          offer: _offers[index],
        ),
      ),
    );
  }
}
