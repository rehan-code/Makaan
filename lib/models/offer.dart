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

class StoreLocation {
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;

  StoreLocation({
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
  });
}

class StoreReview {
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final DateTime date;

  StoreReview({
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class StoreSocial {
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? website;

  StoreSocial({
    this.facebook,
    this.instagram,
    this.twitter,
    this.website,
  });
}

class Offer {
  final String shopName;
  final String shopImage;
  final String offerText;
  final DateTime validity;
  final List<String> tags;
  final String id;
  final RedemptionType redemptionType;
  
  // Additional fields
  final String storeDescription;
  final double rating;
  final int numberOfReviews;
  final String offerDetails;
  final List<String> termsAndConditions;
  final StoreLocation location;
  final StoreSocial social;
  final List<StoreReview> reviews;

  Offer({
    required this.shopName,
    required this.shopImage,
    required this.offerText,
    required this.validity,
    required this.tags,
    required this.id,
    required this.redemptionType,
    required this.storeDescription,
    required this.rating,
    required this.numberOfReviews,
    required this.offerDetails,
    required this.termsAndConditions,
    required this.location,
    required this.social,
    required this.reviews,
  });
}
