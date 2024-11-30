class BusinessDetails {
  final String businessName;
  final String description;
  final List<String> tags;
  final bool isHalal;
  final bool isHalalCertified;
  final String location;
  final List<SocialLink> socialLinks;
  final String? phoneNumber;
  final String userId;

  BusinessDetails({
    required this.businessName,
    required this.description,
    required this.tags,
    required this.isHalal,
    required this.isHalalCertified,
    required this.location,
    required this.userId,
    required this.socialLinks,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'business_name': businessName,
      'description': description,
      'tags': tags,
      'is_halal': isHalal,
      'is_halal_certified': isHalalCertified,
      'location': location,
      'social_links': socialLinks.map((link) => link.toJson()).toList(),
      'phone_number': phoneNumber,
      'user_id': userId,
    };
  }

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      businessName: json['business_name'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags']),
      isHalal: json['is_halal'] as bool,
      isHalalCertified: json['is_halal_certified'] as bool,
      location: json['location'] as String,
      socialLinks: (json['social_links'] as List)
          .map((link) => SocialLink.fromJson(link as Map<String, dynamic>))
          .toList(),
      phoneNumber: json['phone_number'] as String?,
      userId: json['user_id'] as String,
    );
  }
}

class SocialLink {
  final String platform;
  final String url;

  SocialLink({
    required this.platform,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
    };
  }

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      platform: json['platform'] as String,
      url: json['url'] as String,
    );
  }
}
