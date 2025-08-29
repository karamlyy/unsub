import 'package:flutter/material.dart';

enum SubscriptionCategory { video, music, storage, productivity, other, messenger, ai, game}

class Subscription {
  final int id;
  final String name;
  final String vendor;
  final SubscriptionCategory category;
  final double price;
  final DateTime nextBilling;
  final String imageAsset;
  final Color? badgeColor;

  const Subscription({
    required this.id,
    required this.name,
    required this.vendor,
    required this.category,
    required this.price,
    required this.nextBilling,
    required this.imageAsset,
    this.badgeColor,
  });
}