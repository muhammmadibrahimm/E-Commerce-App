import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../database/database_helper.dart';

class ProductProvider with ChangeNotifier {
  List _products = [];
  List _filteredProducts = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List get products => _filteredProducts;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.insert(0, 'All');
    return cats;
  }

  Future loadProducts() async {
    _products = await DatabaseHelper.instance.getProducts();
    _applyFilters();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}