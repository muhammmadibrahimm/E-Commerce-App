import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../database/database_helper.dart';

class CartProvider with ChangeNotifier {
  List _items = [];

  List get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  Future loadCart() async {
    _items = await DatabaseHelper.instance.getCartItems();
    for (var item in _items) {
      final products = await DatabaseHelper.instance.getProducts();
      item.product = products.firstWhere((p) => p.id == item.productId);
    }
    notifyListeners();
  }

  Future addItem(Product product) async {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      final existingItem = _items[existingIndex];
      final updatedItem = CartItem(
        id: existingItem.id,
        productId: existingItem.productId,
        quantity: existingItem.quantity + 1,
        addedDate: existingItem.addedDate,
        product: existingItem.product,
      );
      await DatabaseHelper.instance.updateCartItem(updatedItem);
    } else {
      final newItem = CartItem(
        productId: product.id!,
        quantity: 1,
        addedDate: DateTime.now().toIso8601String(),
        product: product,
      );
      await DatabaseHelper.instance.addToCart(newItem);
    }

    await loadCart();
  }

  Future removeItem(int cartItemId) async {
    await DatabaseHelper.instance.deleteCartItem(cartItemId);
    await loadCart();
  }

  Future updateQuantity(CartItem item, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(item.id!);
    } else {
      final updatedItem = CartItem(
        id: item.id,
        productId: item.productId,
        quantity: newQuantity,
        addedDate: item.addedDate,
        product: item.product,
      );
      await DatabaseHelper.instance.updateCartItem(updatedItem);
      await loadCart();
    }
  }

  Future clearCart() async {
    await DatabaseHelper.instance.clearCart();
    _items = [];
    notifyListeners();
  }
}