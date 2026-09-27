import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_easy/UserApp/model/productmodel/product_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final DateTime date;
  final List<ProductModel> products;
  final Map<String, int> quantities;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String paymentMethod;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
    required this.quantities,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.status,
  });

  int get items {
    int count = 0;

    for (final product in products) {
      count += quantities[product.id] ?? 1;
    }

    return count;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final productsList = map["products"] as List<dynamic>? ?? [];

    final rawQuantities = map["quantities"] as Map<dynamic, dynamic>? ?? {};

    final Map<String, int> parsedQuantities = {};

    rawQuantities.forEach((key, value) {
      parsedQuantities[key.toString()] = (value as num?)?.toInt() ?? 1;
    });

    return OrderModel(
      id: map["id"]?.toString() ?? "",

      userId: map["userId"]?.toString() ?? "",

      date: map["date"] is Timestamp
          ? (map["date"] as Timestamp).toDate()
          : DateTime.now(),

      products: productsList.map((product) {
        return ProductModel.fromMap(Map<String, dynamic>.from(product));
      }).toList(),

      quantities: parsedQuantities,

      subtotal: (map["subtotal"] as num?)?.toDouble() ?? 0.0,

      deliveryFee: (map["deliveryFee"] as num?)?.toDouble() ?? 0.0,

      discount: (map["discount"] as num?)?.toDouble() ?? 0.0,

      total: (map["total"] as num?)?.toDouble() ?? 0.0,

      paymentMethod: map["paymentMethod"]?.toString() ?? "",

      status: map["status"]?.toString() ?? "Pending",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,

      "date": Timestamp.fromDate(date),

      "products": products.map((product) {
        return {
          "id": product.id,
          "name": product.name,
          "image": product.image,
          "category": product.category,
          "description": product.description,
          "price": product.price,
          "rating": product.rating,
        };
      }).toList(),

      "quantities": quantities,

      "subtotal": subtotal,
      "deliveryFee": deliveryFee,
      "discount": discount,
      "total": total,

      "paymentMethod": paymentMethod,

      "status": status,
    };
  }
}
