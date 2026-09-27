import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easy/AdminApp/provider/admin_order_view_model.dart';
import 'package:shop_easy/UserApp/UI/Screens/order_screen/OrderDetailScreen/order_detail_screen.dart';
import 'package:shop_easy/UserApp/core/constant/colors.dart';
import 'package:shop_easy/UserApp/core/constant/text_style.dart';
import 'package:shop_easy/UserApp/model/orderModel/order_model.dart';

class AdminOrdersScreen extends StatefulWidget {
const AdminOrdersScreen({
super.key,
});

@override
State<AdminOrdersScreen> createState() =>
_AdminOrdersScreenState();
}

class _AdminOrdersScreenState
extends State<AdminOrdersScreen> {
final TextEditingController searchController =
TextEditingController();

@override
void initState() {
super.initState();

WidgetsBinding.instance.addPostFrameCallback((_) {
context.read<AdminOrderProvider>().getOrders();
});
}

@override
void dispose() {
searchController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Consumer<AdminOrderProvider>(
builder: (
context,
provider,
child,
) {
return Scaffold(
backgroundColor: backgroundColor,

appBar: AppBar(
backgroundColor: whiteColor,
elevation: 0,

title: Text(
"Orders",
style: style16.copyWith(
fontWeight: FontWeight.bold,
color: boldTextColor,
),
),

actions: [
IconButton(
onPressed: provider.isLoading
? null
    : () {
provider.getOrders();
},
icon: const Icon(
Icons.refresh,
color: Colors.black,
),
),
],
),


body: Padding(
padding: const EdgeInsets.all(16),

child: Column(
children: [


TextField(
controller: searchController,

onChanged: (value) {
provider.searchOrder(value);
},

decoration: InputDecoration(
hintText: "Search order...",

prefixIcon: const Icon(
Icons.search,
),

suffixIcon:
provider.searchText.isNotEmpty
? IconButton(
onPressed: () {
searchController.clear();

provider.searchOrder("");
},
icon: const Icon(
Icons.close,
),
)
    : null,

filled: true,
fillColor: whiteColor,

border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(10),

borderSide:
BorderSide.none,
),
),
),

const SizedBox(height: 15),


Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
Text(
"${provider.filteredOrders.length} Orders",
style: style14.copyWith(
color: secondaryColor,
),
),

if (provider.searchText.isNotEmpty)
Text(
"Searching...",
style: style15.copyWith(
fontSize: 11,
color: secondaryColor,
),
),
],
),

const SizedBox(height: 10),

Expanded(
child: provider.isLoading
? const Center(
child:
CircularProgressIndicator(),
)
    : provider.error.isNotEmpty
? _errorWidget(
provider,
)
    : provider
    .filteredOrders
    .isEmpty
? const Center(
child: Text(
"No orders found",
),
)
    : RefreshIndicator(
onRefresh: () {
return provider
    .getOrders();
},

child:
ListView.builder(
physics:
const AlwaysScrollableScrollPhysics(),

itemCount: provider
    .filteredOrders
    .length,

itemBuilder:
(
context,
index,
) {
final order =
provider
    .filteredOrders[
index];

return _orderCard(
context,
order,
);
},
),
),
),
],
),
),
);
},
);
}


Widget _errorWidget(
AdminOrderProvider provider,
) {
return Center(
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,

children: [
const Icon(
Icons.error_outline,
color: Colors.red,
size: 40,
),

const SizedBox(height: 10),

Text(
provider.error,
textAlign: TextAlign.center,

style: const TextStyle(
color: Colors.red,
),
),

const SizedBox(height: 12),

ElevatedButton(
onPressed: () {
provider.getOrders();
},

child: const Text(
"Try Again",
),
),
],
),
);
}



Widget _orderCard(
BuildContext context,
OrderModel order,
) {
return Container(
margin: const EdgeInsets.only(
bottom: 10,
),

padding: const EdgeInsets.all(12),

decoration: BoxDecoration(
color: whiteColor,

borderRadius:
BorderRadius.circular(12),
),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [



Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
Expanded(
child: Text(
"#${order.id}",

maxLines: 1,

overflow:
TextOverflow.ellipsis,

style: style14.copyWith(
fontWeight:
FontWeight.bold,
),
),
),

const SizedBox(width: 10),

_statusWidget(
order.status,
),
],
),

const SizedBox(height: 5),



Text(
_formatDate(order.date),

style: style15.copyWith(
fontSize: 12,
color: secondaryColor,
),
),

const SizedBox(height: 12),



Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
Text(
"Customer",

style: style15.copyWith(
fontSize: 12,
color: secondaryColor,
),
),

const SizedBox(width: 10),

Expanded(
child: Text(
order.userId,

textAlign: TextAlign.right,

maxLines: 1,

overflow:
TextOverflow.ellipsis,

style: style14,
),
),
],
),

const SizedBox(height: 7),


Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
Text(
"Payment",

style: style15.copyWith(
fontSize: 12,
color: secondaryColor,
),
),

Text(
order.paymentMethod,

style: style14,
),
],
),

const SizedBox(height: 7),



Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [
Text(
"Items",

style: style15.copyWith(
fontSize: 12,
color: secondaryColor,
),
),

Text(
"${order.items}",

style: style14.copyWith(
fontWeight:
FontWeight.w600,
),
),
],
),

const SizedBox(height: 12),

const Divider(),

const SizedBox(height: 5),


Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,

children: [

Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
Text(
"TOTAL AMOUNT",

style: style15.copyWith(
fontSize: 9,
color: secondaryColor,
),
),

const SizedBox(height: 3),

Text(
"\$${order.total.toStringAsFixed(2)}",

style: style14.copyWith(
color: Colors.teal,
fontWeight:
FontWeight.bold,
),
),
],
),

// VIEW DETAILS
OutlinedButton(
onPressed: () async {
await Navigator.push(
context,

MaterialPageRoute(
builder: (context) =>
OrderDetailsScreen(
order: order,
),
),
);

// Detail screen se wapis aane ke baad
// latest data Firestore se load karo.
if (context.mounted) {
context
    .read<AdminOrderProvider>()
    .getOrders();
}
},

style:
OutlinedButton.styleFrom(
padding:
const EdgeInsets.symmetric(
horizontal: 10,
),

side: BorderSide(
color: secondaryColor
    .withOpacity(0.3),
),

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(8),
),
),

child: const Text(
"View Details",
),
),
],
),
],
),
);
}



Widget _statusWidget(
String status,
) {
Color background;
Color textColor;

switch (status) {
case "Delivered":
background =
Colors.green.withOpacity(0.15);
textColor = Colors.green;
break;

case "Cancelled":
background =
Colors.red.withOpacity(0.15);
textColor = Colors.red;
break;

case "Processing":
background =
Colors.blue.withOpacity(0.15);
textColor = Colors.blue;
break;

case "Pending":
default:
background =
Colors.orange.withOpacity(0.15);
textColor = Colors.orange;
break;
}

return Container(
padding:
const EdgeInsets.symmetric(
horizontal: 10,
vertical: 5,
),

decoration: BoxDecoration(
color: background,

borderRadius:
BorderRadius.circular(20),
),

child: Text(
status,

style: TextStyle(
fontSize: 11,
fontWeight:
FontWeight.w600,
color: textColor,
),
),
);
}



String _formatDate(
DateTime date,
) {
return "${date.day.toString().padLeft(2, '0')}/"
"${date.month.toString().padLeft(2, '0')}/"
"${date.year} "
"${date.hour.toString().padLeft(2, '0')}:"
"${date.minute.toString().padLeft(2, '0')}";
}
}

