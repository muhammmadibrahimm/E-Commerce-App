class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int stock;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.stock,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
        'rating': rating,
        'stock': stock,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int?,
        name: json['name'] as String,
        description: json['description'] as String,
        price: json['price'] as double,
        imageUrl: json['imageUrl'] as String,
        category: json['category'] as String,
        rating: json['rating'] as double,
        stock: json['stock'] as int,
      );

  Product copy({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    int? stock,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        category: category ?? this.category,
        rating: rating ?? this.rating,
        stock: stock ?? this.stock,
      );
}