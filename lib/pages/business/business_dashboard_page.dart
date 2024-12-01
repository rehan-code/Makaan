import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/coupon.dart';

class BusinessDashboardPage extends StatefulWidget {
  const BusinessDashboardPage({super.key});

  @override
  State<BusinessDashboardPage> createState() => _BusinessDashboardPageState();
}

class _BusinessDashboardPageState extends State<BusinessDashboardPage> {
  List<Coupon> _coupons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final response = await Supabase.instance.client
          .from('coupons')
          .select()
          .eq('business_id', userId)
          .order('created_at', ascending: false);

      setState(() {
        _coupons = (response as List).map((data) => Coupon.fromJson(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading coupons: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCreateCouponDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateCouponDialog(
        onCouponCreated: () {
          _loadCoupons();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Your Coupons',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: _coupons.isEmpty
                      ? const Center(
                          child: Text('No coupons created yet'),
                        )
                      : ListView.builder(
                          itemCount: _coupons.length,
                          itemBuilder: (context, index) {
                            final coupon = _coupons[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: ListTile(
                                title: Text(coupon.code),
                                subtitle: Text(
                                  '${coupon.description}\n${coupon.discountPercentage}% off',
                                ),
                                trailing: Text(
                                  'Valid until: ${coupon.validUntil.toString().split(' ')[0]}',
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateCouponDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateCouponDialog extends StatefulWidget {
  final VoidCallback onCouponCreated;

  const CreateCouponDialog({
    super.key,
    required this.onCouponCreated,
  });

  @override
  State<CreateCouponDialog> createState() => _CreateCouponDialogState();
}

class _CreateCouponDialogState extends State<CreateCouponDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountController = TextEditingController();
  DateTime _validUntil = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _createCoupon() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await Supabase.instance.client.from('coupons').insert({
        'code': _codeController.text.trim(),
        'description': _descriptionController.text.trim(),
        'discount_percentage': double.parse(_discountController.text),
        'valid_from': DateTime.now().toIso8601String(),
        'valid_until': _validUntil.toIso8601String(),
        'business_id': userId,
      });

      if (mounted) {
        Navigator.of(context).pop();
        widget.onCouponCreated();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating coupon: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Coupon'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Coupon Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a coupon code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: 'Discount Percentage'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a discount percentage';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0 || number > 100) {
                    return 'Please enter a valid percentage between 0 and 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Valid Until'),
                subtitle: Text(_validUntil.toString().split(' ')[0]),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _validUntil,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _validUntil = date;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createCoupon,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
