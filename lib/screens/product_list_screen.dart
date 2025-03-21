import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  final ApiService _apiService = ApiService(Dio());
  List<Product> _products = [];
  List<String> _categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _apiService.getProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _apiService.getCategories();
      categories.add("All categories");
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> _filterProductsByCategory(String category) async {
    try {
      final products = await _apiService.getProductsByCategory(category);
      setState(() {
        _products = products;
        _selectedCategory = category;
      });
    } catch (e) {
      print('Error filtering products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Commerce App'),
        actions: [
          DropdownButton<String>(
            value: _selectedCategory,
            hint: Text('Filter by Category'),
            onChanged: (String? newValue) {
              if (newValue == null || newValue == 'All categories') {
                _loadProducts();
              } else {
                _filterProductsByCategory(newValue);
              }
            },
            items: _categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            leading: Image.network(product.image, width: 50, height: 50),
            title: Text(product.title),
            subtitle: Text('\$${product.price}'),
          );
        },
      ),
    );
  }
}