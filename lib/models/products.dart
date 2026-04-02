import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String name;
  final String price;
  final String description;
  final String image;
  final String subTitle;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.subTitle,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'],
      price: "\$${json['price']}",
      description: json['description'],
      image: json['thumbnail'],
      subTitle: json['category'],
    );
  }
}

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://dummyjson.com/products'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> productList = data['products'];
    return productList.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Upload has been failed');
  }
}