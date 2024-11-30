class BusinessDetails {
  final String businessName;
  final String description;
  final List<String> tags;
  final bool isHalal;
  final bool isHalalCertified;
  final String location;
  final String? instagram;
  final String? facebook;
  final String? website;
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
    this.instagram,
    this.facebook,
    this.website,
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
      'instagram': instagram,
      'facebook': facebook,
      'website': website,
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
      instagram: json['instagram'] as String?,
      facebook: json['facebook'] as String?,
      website: json['website'] as String?,
      phoneNumber: json['phone_number'] as String?,
      userId: json['user_id'] as String,
    );
  }
}
