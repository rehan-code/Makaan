import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfferPreviewPage extends StatelessWidget {
  final String title;
  final String description;
  final String termsAndConditions;
  final String code;
  final DateTime validUntil;
  final int numCoupons;
  final Function() onConfirm;

  const OfferPreviewPage({
    super.key,
    required this.title,
    required this.description,
    required this.termsAndConditions,
    required this.code,
    required this.validUntil,
    required this.numCoupons,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Offer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text(
                'Terms and Conditions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                termsAndConditions,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Valid Until'),
                subtitle: Text(DateFormat('MMMM d, y').format(validUntil)),
              ),
              ListTile(
                leading: const Icon(Icons.confirmation_number),
                title: const Text('Number of Coupons'),
                subtitle: Text('$numCoupons'),
              ),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Coupon Code'),
                subtitle: Text(code),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Confirm and Create Offer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
