
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_easy/AdminApp/UI/utills/show_message.dart';
import 'package:shop_easy/UserApp/model/orderModel/order_model.dart';

class AdminOrderProvider extends ChangeNotifier {
final FirebaseFirestore firestore =
FirebaseFirestore.instance;

List<OrderModel> orders = [];

bool isLoading = false;

String error = "";

String searchText = "";



List<OrderModel> get filteredOrders {
if (searchText.trim().isEmpty) {
return orders;
}

final search = searchText.trim().toLowerCase();

return orders.where((order) {
return order.id.toLowerCase().contains(search) ||
order.userId.toLowerCase().contains(search) ||
order.status.toLowerCase().contains(search);
}).toList();
}



Future<void> getOrders() async {
try {
isLoading = true;
error = "";

notifyListeners();

final snapshot = await firestore
    .collection("orders")
    .orderBy(
"date",
descending: true,
)
    .get();

orders = snapshot.docs.map((doc) {
final data = doc.data();

return OrderModel.fromMap({
...data,

// Firestore document ID ko fallback ke taur par use karo
"id": data["id"] ?? doc.id,
});
}).toList();
} catch (e) {
error = "Failed to load orders: $e";
} finally {
isLoading = false;

notifyListeners();
}
}


void searchOrder(String value) {
searchText = value;

notifyListeners();
}



Future<bool> updateOrderStatus(
String orderId,
String status,
) async {
try {
isLoading = true;
error = "";

notifyListeners();



DocumentReference orderRef =
firestore.collection("orders").doc(orderId);

DocumentSnapshot orderSnapshot =
await orderRef.get();

// Agar document ID order.id ke equal nahi hai,
// to id field se document find karne ki koshish karo.
if (!orderSnapshot.exists) {
final query = await firestore
    .collection("orders")
    .where(
"id",
isEqualTo: orderId,
)
    .limit(1)
    .get();

if (query.docs.isEmpty) {
showMsg(
"Order not found",
);

return false;
}

orderRef = query.docs.first.reference;
}


await orderRef.update({
"status": status,
});

final index = orders.indexWhere(
(order) => order.id == orderId,
);

if (index != -1) {
final oldOrder = orders[index];

orders[index] = OrderModel(
id: oldOrder.id,
userId: oldOrder.userId,
date: oldOrder.date,
products: oldOrder.products,
quantities: oldOrder.quantities,
subtotal: oldOrder.subtotal,
deliveryFee: oldOrder.deliveryFee,
discount: oldOrder.discount,
total: oldOrder.total,
paymentMethod: oldOrder.paymentMethod,
status: status,
);
}

showMsg(
"Order status updated successfully",
false,
);

return true;
} catch (e) {
error = "Failed to update order status: $e";

showMsg(
"Failed to update order status: $e",
);

return false;
} finally {
isLoading = false;

notifyListeners();
}
}



OrderModel? getOrder(String id) {
try {
return orders.firstWhere(
(order) => order.id == id,
);
} catch (e) {
return null;
}
}
}

