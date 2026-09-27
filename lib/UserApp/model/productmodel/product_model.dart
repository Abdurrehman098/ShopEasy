import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final String description;
  final double price;
  final double rating;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.description,
    required this.price,
    required this.rating,
    required this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map["id"]?.toString() ?? "",

      name: map["name"]?.toString() ?? "",

      // Example:
      // assets/static_assets/blackSneaker.png
      image: map["image"]?.toString() ?? "",

      category: map["category"]?.toString() ?? "",

      description: map["description"]?.toString() ?? "",

      price: _toDouble(map["price"]),

      rating: _toDouble(map["rating"]),

      createdAt: _toDateTime(map["createdAt"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "category": category,
      "description": description,
      "price": price,
      "rating": rating,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? "0") ?? 0.0;
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}