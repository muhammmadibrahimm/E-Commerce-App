import 'product.dart';

class CartItem {
  final int? id;
  final int productId;
  final int quantity;
  final String addedDate;
  Product? product;

  CartItem({
    this.id,
    required this.productId,
    required this.quantity,
    required this.addedDate,
    this.product,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'quantity': quantity,
        'addedDate': addedDate,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] as int?,
        productId: json['productId'] as int,
        quantity: json['quantity'] as int,
        addedDate: json['addedDate'] as String,
      );

  double get totalPrice => (product?.price ?? 0) * quantity;
}