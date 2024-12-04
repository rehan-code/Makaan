import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:makaan/models/business_details.dart';
import 'package:makaan/models/coupon.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfferDetailsPage extends StatefulWidget {
  final Coupon coupon;
  final BusinessDetails business;

  const OfferDetailsPage({
    super.key,
    required this.coupon,
    required this.business,
  });

  @override
  State<OfferDetailsPage> createState() => _OfferDetailsPageState();
}

class _OfferDetailsPageState extends State<OfferDetailsPage> {
  bool _isCodeRevealed = false;
  String? _revealedCode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkRevealedCode();
  }

  Future<void> _checkRevealedCode() async {
    if (widget.coupon.assignmentId == null) {
      // print('No assignment ID available');
      return;
    }

    if (widget.coupon.isRevealed != null && widget.coupon.isRevealed!) {
      try {
        final response = await Supabase.instance.client
            .from('coupon_assignments')
            .select('coupons (code)')
            .eq('id', widget.coupon.assignmentId)
            .single();

        if (mounted && response != null && response['coupons'] != null) {
          setState(() {
            _revealedCode = response['coupons']['code'] as String;
            _isCodeRevealed = true;
          });
        }
      } catch (e) {
        // print('Error fetching revealed code: $e');
        // Reset the revealed state if we can't fetch the code
        if (mounted) {
          setState(() {
            widget.coupon.isRevealed = false;
            _isCodeRevealed = false;
            _revealedCode = null;
          });
        }
      }
    }
  }

  Future<void> _revealCode() async {
    if (widget.coupon.assignmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No assignment ID available for this coupon'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final response = await Supabase.instance.client
          .rpc('reveal_coupon_code', params: {
        'p_assignment_id': widget.coupon.assignmentId,
      });

      if (!mounted) return;

      if (response != null && response is List && response.isNotEmpty && response[0]['code'] != null) {
        setState(() {
          _revealedCode = response[0]['code'] as String;
          _isCodeRevealed = true;
          widget.coupon.isRevealed = true;
        });
      } else {
        throw Exception('Invalid response format from reveal_coupon_code');
      }
    } catch (e) {
      // print('Error revealing code: $e');
      // print('Assignment ID: ${widget.coupon.assignmentId}');
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reveal code: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );

      // Reset states on error
      setState(() {
        widget.coupon.isRevealed = false;
        _isCodeRevealed = false;
        _revealedCode = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _launchURL(String? url) async {
    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  void _openMap() async {
    // TODO: Add proper location handling
    final url = 'https://www.google.com/maps/search/?api=1&query=0,0';
    _launchURL(url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 110,
            pinned: true,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black87, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon:
                      const Icon(Icons.share, color: Colors.black87, size: 20),
                  onPressed: () {
                    Share.share(
                      '${widget.business.businessName}: ${widget.coupon.title}',
                      subject: 'Check out this amazing offer!',
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80', // TODO: Add business image
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Info Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.business.businessName,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.amber[600], size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      '4.5', // TODO: Add ratings system
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.store, // TODO: Add redemption type
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'In Store', // TODO: Add redemption type
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Tags
                      SizedBox(
                        height: 32,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.business.tags.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  widget.business.tags[index],
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.business.description.length > 240
                            ? '${widget.business.description.substring(0, 240)}...'
                            : widget.business.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),

                // Offer Details Section
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Offer Text
                      Text(
                        'OFFER DETAILS',
                        style: theme.textTheme.titleSmall?.copyWith(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.coupon.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.coupon.description,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 20, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Valid until ${DateFormat('dd MMM yyyy').format(widget.coupon.validUntil)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Coupon Code Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            if (_isCodeRevealed && _revealedCode != null)
                              Column(
                                children: [
                                  Text(
                                    'YOUR COUPON CODE',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _revealedCode!,
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else
                              ElevatedButton(
                                onPressed: _isLoading ? null : _revealCode,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('REVEAL CODE'),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // Terms and Conditions
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TERMS & CONDITIONS',
                        style: theme.textTheme.titleSmall?.copyWith(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...widget.coupon.termsAndConditions.split('\n').map((term) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ',
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.grey[800])),
                                Expanded(
                                  child: Text(
                                    term,
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.grey[800]),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

                // Location
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOCATION',
                        style: theme.textTheme.titleSmall?.copyWith(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _openMap,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.business.location,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    // TODO: Add detailed location info
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Social Links
                if (widget.business.socialLinks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FOLLOW US',
                          style: theme.textTheme.titleSmall?.copyWith(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: widget.business.socialLinks.map((link) {
                            IconData icon;
                            switch (link.platform.toLowerCase()) {
                              case 'instagram':
                                icon = Icons.camera_alt_outlined;
                                break;
                              case 'facebook':
                                icon = Icons.facebook;
                                break;
                              case 'twitter':
                                icon = FontAwesomeIcons.xTwitter;
                                break;
                              case 'website':
                                icon = Icons.language;
                                break;
                              default:
                                icon = Icons.link;
                            }
                            return IconButton(
                              onPressed: () => _launchURL(link.url),
                              icon: Icon(icon),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
