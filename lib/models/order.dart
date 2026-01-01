import 'dart:convert';

class Order {
  final int? id;
  final String orderDate;
  final double totalAmount;
  final String status;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String items;

  Order({
    this.id,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderDate': orderDate,
        'totalAmount': totalAmount,
        'status': status,
        'customerName': customerName,
        'customerAddress': customerAddress,
        'customerPhone': customerPhone,
        'items': items,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as int?,
        orderDate: json['orderDate'] as String,
        totalAmount: json['totalAmount'] as double,
        status: json['status'] as String,
        customerName: json['customerName'] as String,
        customerAddress: json['customerAddress'] as String,
        customerPhone: json['customerPhone'] as String,
        items: json['items'] as String,
      );

  List<dynamic> getItemsList() {
    return jsonDecode(items);
  }
}