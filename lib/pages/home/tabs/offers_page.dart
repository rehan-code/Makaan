import 'package:flutter/material.dart';
import 'package:makaan/models/business_details.dart';
import 'package:makaan/models/coupon.dart';
import 'package:makaan/widgets/offer_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<(Coupon, BusinessDetails)> _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    try {
      // Get all coupons
      final response = await Supabase.instance.client
          .from('coupons')
          .select('''
            id,
            title,
            description,
            terms_and_conditions,
            code,
            valid_until,
            business_id,
            created_at,
            num_coupons,
            business:business_details (
              business_name,
              description,
              tags,
              is_halal,
              is_halal_certified,
              location,
              social_links,
              phone_number,
              user_id
            )
          ''')
          .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        _offers = (response as List).map((couponData) {
          final businessData = couponData['business'];
          
          final coupon = Coupon.fromJson({
            ...couponData,
            'assignment_id': null, // No assignment ID since we're showing all coupons
            'is_revealed': false, // Default to not revealed since these are all coupons
          });
          final business = BusinessDetails.fromJson(businessData);

          return (coupon, business);
        }).toList();

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

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
        itemBuilder: (context, index) {
          final (coupon, business) = _offers[index];
          return OfferCard(
            coupon: coupon,
            business: business,
          );
        },
      ),
    );
  }
}
