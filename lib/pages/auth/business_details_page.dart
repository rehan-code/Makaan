import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/business_details.dart';

class BusinessDetailsPage extends StatefulWidget {
  final String userId;

  const BusinessDetailsPage({super.key, required this.userId});

  @override
  State<BusinessDetailsPage> createState() => _BusinessDetailsPageState();
}

class _BusinessDetailsPageState extends State<BusinessDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _newTagController = TextEditingController();
  final _socialLinkController = TextEditingController();
  
  bool _isHalal = false;
  bool _isHalalCertified = false;
  bool _isLoading = false;
  final List<String> _selectedTags = [];
  final List<SocialLink> _socialLinks = [];

  final List<String> _availableTags = [
    'Restaurant',
    'Cafe',
    'Grocery',
    'Retail',
    'Online Store',
    'Food Truck',
    'Bakery',
    'Other'
  ];

  final List<String> _availablePlatforms = [
    'Instagram',
    'Facebook',
    'Twitter',
    'TikTok',
    'YouTube',
    'LinkedIn',
    'Website',
    'Other'
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _newTagController.dispose();
    _socialLinkController.dispose();
    super.dispose();
  }

  void _addCustomTag() {
    final newTag = _newTagController.text.trim();
    if (newTag.isNotEmpty && !_selectedTags.contains(newTag)) {
      setState(() {
        _selectedTags.add(newTag);
        _newTagController.clear();
      });
    }
  }

  void _addSocialLink(String platform) {
    final url = _socialLinkController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        _socialLinks.add(SocialLink(platform: platform, url: url));
        _socialLinkController.clear();
      });
    }
  }

  void _removeSocialLink(int index) {
    setState(() {
      _socialLinks.removeAt(index);
    });
  }

  Future<void> _submitBusinessDetails() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one tag'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final businessDetails = BusinessDetails(
        businessName: _businessNameController.text.trim(),
        description: _descriptionController.text.trim(),
        tags: _selectedTags,
        isHalal: _isHalal,
        isHalalCertified: _isHalalCertified,
        location: _locationController.text.trim(),
        socialLinks: _socialLinks,
        phoneNumber: _phoneController.text.trim(),
        userId: widget.userId,
      );

      await Supabase.instance.client
          .from('business_details')
          .insert(businessDetails.toJson());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business details saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: theme.colorScheme.primary.withOpacity(0.1),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete Your\nBusiness Profile',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your business details to get started',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSectionTitle(theme, 'Basic Information'),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _businessNameController,
                        decoration: _getInputDecoration(
                          'Business Name',
                          Icons.business,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your business name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: _getInputDecoration(
                          'Business Description',
                          Icons.description,
                        ).copyWith(
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your business description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(theme, 'Business Category'),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ..._availableTags.map((tag) {
                            final isSelected = _selectedTags.contains(tag);
                            return FilterChip(
                              label: Text(tag),
                              selected: isSelected,
                              showCheckmark: false,
                              backgroundColor: theme.colorScheme.surface,
                              selectedColor: theme.colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.transparent
                                      : theme.colorScheme.outline.withOpacity(0.5),
                                ),
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedTags.add(tag);
                                  } else {
                                    _selectedTags.remove(tag);
                                  }
                                });
                              },
                            );
                          }),
                          ..._selectedTags
                              .where((tag) => !_availableTags.contains(tag))
                              .map((tag) => Chip(
                                    label: Text(
                                      tag,
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    backgroundColor: theme.colorScheme.primary,
                                    deleteIconColor: theme.colorScheme.onPrimary,
                                    onDeleted: () {
                                      setState(() {
                                        _selectedTags.remove(tag);
                                      });
                                    },
                                  )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _newTagController,
                              decoration: _getInputDecoration(
                                'Add Custom Tag',
                                Icons.local_offer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: _addCustomTag,
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(theme, 'Halal Status'),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 0,
                        color: theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text('Halal'),
                              value: _isHalal,
                              onChanged: (value) {
                                setState(() {
                                  _isHalal = value;
                                  if (!value) _isHalalCertified = false;
                                });
                              },
                            ),
                            if (_isHalal)
                              SwitchListTile(
                                title: const Text('Halal Certified'),
                                value: _isHalalCertified,
                                onChanged: (value) {
                                  setState(() {
                                    _isHalalCertified = value;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(theme, 'Location'),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: _getInputDecoration(
                          'Business Location',
                          Icons.location_on,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your business location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(theme, 'Social Links'),
                      const SizedBox(height: 16),
                      if (_socialLinks.isNotEmpty) ...[
                        Card(
                          elevation: 0,
                          color: theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: theme.colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _socialLinks.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                              color: theme.colorScheme.outline.withOpacity(0.2),
                            ),
                            itemBuilder: (context, index) {
                              final link = _socialLinks[index];
                              return ListTile(
                                leading: Icon(
                                  _getSocialIcon(link.platform),
                                  color: theme.colorScheme.primary,
                                ),
                                title: Text(link.platform),
                                subtitle: Text(
                                  link.url,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _removeSocialLink(index),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _socialLinkController,
                              decoration: _getInputDecoration(
                                'URL',
                                Icons.link,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            icon: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.add,
                                color: theme.colorScheme.onPrimary,
                                size: 24,
                              ),
                            ),
                            position: PopupMenuPosition.under,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onSelected: _addSocialLink,
                            itemBuilder: (BuildContext context) {
                              return _availablePlatforms.map((String platform) {
                                return PopupMenuItem<String>(
                                  value: platform,
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getSocialIcon(platform),
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(platform),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(theme, 'Contact'),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: _getInputDecoration(
                          'Phone Number (optional)',
                          Icons.phone,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: _isLoading ? null : _submitBusinessDetails,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save Business Details'),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  InputDecoration _getInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
    );
  }

  IconData _getSocialIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt;
      case 'facebook':
        return Icons.facebook;
      case 'twitter':
        return Icons.flutter_dash;
      case 'tiktok':
        return Icons.music_note;
      case 'youtube':
        return Icons.play_circle;
      case 'linkedin':
        return Icons.work;
      case 'website':
        return Icons.language;
      default:
        return Icons.link;
    }
  }
}
