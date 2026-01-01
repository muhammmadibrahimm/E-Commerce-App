import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../database/database_helper.dart';
import 'dart:convert';

class OrderProvider with ChangeNotifier {
  List _orders = [];

  List get orders => _orders;

  Future loadOrders() async {
    _orders = await DatabaseHelper.instance.getOrders();
    notifyListeners();
  }

  Future createOrder({
    required double totalAmount,
    required String customerName,
    required String customerAddress,
    required String customerPhone,
    required List<Map> items,
  }) async {
    final order = Order(
      orderDate: DateTime.now().toIso8601String(),
      totalAmount: totalAmount,
      status: 'Pending',
      customerName: customerName,
      customerAddress: customerAddress,
      customerPhone: customerPhone,
      items: jsonEncode(items),
    );

    await DatabaseHelper.instance.createOrder(order);
    await loadOrders();
  }
}