import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

final List<String> categories = [
  'Grain',
  'Vegetable',
  'Fruit',
  'Meat',
  'Dairy',
  'Spice',
  'Frozen',
  'Other'
];
final List<String> units = ['kg', 'litres', 'packets', 'pieces'];

class FoodItemModel {
  final String? id;
  final String uid;
  final String name;
  final int quantity;
  final String category;
  final String unit;
  final Timestamp expiryDate;
  final Timestamp createdAt;
  FoodItemModel({
    this.id,
    required this.uid,
    required this.name,
    required this.quantity,
    required this.category,
    required this.unit,
    required this.expiryDate,
    required this.createdAt,
  });

  FoodItemModel copyWith({
    String? id,
    String? uid,
    String? name,
    int? quantity,
    String? category,
    String? unit,
    Timestamp? expiryDate,
    Timestamp? createdAt,
  }) {
    return FoodItemModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'quantity': quantity,
      'category': category,
      'unit': unit,
      'expiryDate': expiryDate,
      'createdAt': createdAt,
    };
  }

  factory FoodItemModel.fromMap(Map<String, dynamic> map) {
    return FoodItemModel(
      id: map['id'],
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      category: map['category'] ?? '',
      unit: map['unit'] ?? '',
      expiryDate: map['expiryDate'],
      createdAt: map['createdAt'],
    );
  }
}
