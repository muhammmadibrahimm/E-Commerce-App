import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ecommerce.db');
    return _database!;
  }

  Future _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE products (
        id $idType,
        name $textType,
        description $textType,
        price $realType,
        imageUrl $textType,
        category $textType,
        rating $realType,
        stock $integerType
      )
    ''');

    await db.execute('''
      CREATE TABLE cart (
        id $idType,
        productId $integerType,
        quantity $integerType,
        addedDate $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id $idType,
        orderDate $textType,
        totalAmount $realType,
        status $textType,
        customerName $textType,
        customerAddress $textType,
        customerPhone $textType,
        items $textType
      )
    ''');

    await _insertSampleProducts(db);
  }

  Future _insertSampleProducts(Database db) async {
    final products = [
      {
        'name': 'Wireless Headphones',
        'description': 'Premium noise-canceling wireless headphones with 30-hour battery life',
        'price': 199.99,
        'imageUrl': 'https://via.placeholder.com/300x300.png?text=Headphones',
        'category': 'Electronics',
        'rating': 4.5,
        'stock': 50
      },
      {
        'name': 'Smart Watch',
        'description': 'Fitness tracking smartwatch with heart rate monitor',
        'price': 299.99,
        'imageUrl': 'https://via.placeholder.com/300x300.png?text=Smart+Watch',
        'category': 'Electronics',
        'rating': 4.7,
        'stock': 30
      },
      {
        'name': 'Running Shoes',
        'description': 'Comfortable running shoes with excellent cushioning',
        'price': 89.99,
        'imageUrl': 'https://via.placeholder.com/300x300.png?text=Running+Shoes',
        'category': 'Fashion',
        'rating': 4.3,
        'stock': 100
      },
      {
        'name': 'Backpack',
        'description': 'Durable laptop backpack with multiple compartments',
        'price': 49.99,
        'imageUrl': 'https://via.placeholder.com/300x300.png?text=Backpack',
        'category': 'Fashion',
        'rating': 4.6,
        'stock': 75
      },
      {
        'name': 'Coffee Maker',
        'description': 'Programmable coffee maker with thermal carafe',
        'price': 79.99,
        'imageUrl': 'https://via.placeholder.com/300x300.png?text=Coffee+Maker',
        'category': 'Home',
        'rating': 4.4,
        'stock': 40
      },
      {
        'name': 'Yoga Mat',
        'description': 'Non-slip eco-friendly yoga mat',
        'price': 29.99,
        'imageUrl': 'https://via.placeholder.com/300x300.png?text=Yoga+Mat',
        'category': 'Sports',
        'rating': 4.8,
        'stock': 120
      },
      {
        'name': 'Bluetooth Speaker',
        'description': 'Portable waterproof Bluetooth speaker',
        'price': 59.99,
        'imageUrl': 'https://via.placeholder.com/300x300.png?text=Speaker',
        'category': 'Electronics',
        'rating': 4.5,
        'stock': 60
      },
      {
        'name': 'Water Bottle',
        'description': 'Insulated stainless steel water bottle',
        'price': 24.99,
        'imageUrl': 'https://via.placeholder.com/300x300.png?text=Water+Bottle',
        'category': 'Sports',
        'rating': 4.7,
        'stock': 200
      },
    ];

    for (var product in products) {
      await db.insert('products', product);
    }
  }

  Future<List> getProducts() async {
    final db = await instance.database;
    final result = await db.query('products');
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<List> getProductsByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<List> searchProducts(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'products',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future addToCart(CartItem item) async {
    final db = await instance.database;
    return await db.insert('cart', item.toJson());
  }

  Future<List> getCartItems() async {
    final db = await instance.database;
    final result = await db.query('cart');
    return result.map((json) => CartItem.fromJson(json)).toList();
  }

  Future updateCartItem(CartItem item) async {
    final db = await instance.database;
    return await db.update(
      'cart',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future deleteCartItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future clearCart() async {
    final db = await instance.database;
    return await db.delete('cart');
  }

  Future createOrder(Order order) async {
    final db = await instance.database;
    return await db.insert('orders', order.toJson());
  }

  Future<List> getOrders() async {
    final db = await instance.database;
    final result = await db.query('orders', orderBy: 'orderDate DESC');
    return result.map((json) => Order.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}