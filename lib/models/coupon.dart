class Coupon {
  final String id;
  final String title;
  final String description;
  final String termsAndConditions;
  final String code;
  final DateTime validUntil;
  final String businessId;
  final DateTime createdAt;
  final int numCoupons;

  Coupon({
    required this.id,
    required this.title,
    required this.description,
    required this.termsAndConditions,
    required this.code,
    required this.validUntil,
    required this.businessId,
    required this.createdAt,
    required this.numCoupons,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      termsAndConditions: json['terms_and_conditions'],
      code: json['code'],
      validUntil: DateTime.parse(json['valid_until']),
      businessId: json['business_id'],
      createdAt: DateTime.parse(json['created_at']),
      numCoupons: json['num_coupons'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'terms_and_conditions': termsAndConditions,
      'code': code,
      'valid_until': validUntil.toIso8601String(),
      'business_id': businessId,
      'created_at': createdAt.toIso8601String(),
      'num_coupons': numCoupons,
    };
  }
}
