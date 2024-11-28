import 'package:flutter/material.dart';

enum RedemptionType {
  inStore,
  online,
  both;

  String get displayText {
    switch (this) {
      case RedemptionType.inStore:
        return 'In-store only';
      case RedemptionType.online:
        return 'Online only';
      case RedemptionType.both:
        return 'Online & In-store';
    }
  }

  IconData get icon {
    switch (this) {
      case RedemptionType.inStore:
        return Icons.store;
      case RedemptionType.online:
        return Icons.language;
      case RedemptionType.both:
        return Icons.storefront;
    }
  }
}

class Offer {
  final String shopName;
  final String shopImage;
  final String offerText;
  final DateTime validity;
  final List<String> tags;
  final String id;
  final RedemptionType redemptionType;

  Offer({
    required this.shopName,
    required this.shopImage,
    required this.offerText,
    required this.validity,
    required this.tags,
    required this.id,
    required this.redemptionType,
  });
}
