import 'package:equatable/equatable.dart';

class SubscriptionModel extends Equatable {
  const SubscriptionModel({
    required this.id,
    required this.name,
    this.category,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.firstPaymentDate,
    required this.nextPaymentDate,
    required this.isActive,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String? category;
  final double price;
  final String currency;
  final String billingCycle; // DAILY / WEEKLY / MONTHLY / YEARLY
  final DateTime firstPaymentDate;
  final DateTime nextPaymentDate;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String?,
      price: _parseDouble(json['price']),
      currency: json['currency'] as String,
      billingCycle: json['billingCycle'] as String,
      firstPaymentDate: DateTime.parse(json['firstPaymentDate'] as String),
      nextPaymentDate: DateTime.parse(json['nextPaymentDate'] as String),
      isActive: json['isActive'] as bool,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  SubscriptionModel copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    String? currency,
    String? billingCycle,
    DateTime? firstPaymentDate,
    DateTime? nextPaymentDate,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      firstPaymentDate: firstPaymentDate ?? this.firstPaymentDate,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    price,
    currency,
    billingCycle,
    firstPaymentDate,
    nextPaymentDate,
    isActive,
    notes,
    createdAt,
    updatedAt,
  ];


  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}