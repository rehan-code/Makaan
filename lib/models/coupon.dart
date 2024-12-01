class Coupon {
  final String id;
  final String code;
  final String description;
  final double discountPercentage;
  final DateTime validFrom;
  final DateTime validUntil;
  final String businessId;
  final DateTime createdAt;

  Coupon({
    required this.id,
    required this.code,
    required this.description,
    required this.discountPercentage,
    required this.validFrom,
    required this.validUntil,
    required this.businessId,
    required this.createdAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      discountPercentage: json['discount_percentage'].toDouble(),
      validFrom: DateTime.parse(json['valid_from']),
      validUntil: DateTime.parse(json['valid_until']),
      businessId: json['business_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discount_percentage': discountPercentage,
      'valid_from': validFrom.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
      'business_id': businessId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
