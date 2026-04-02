import 'package:flutter/material.dart';
import 'models/products.dart';
import 'screens/discover_screen.dart';

void main() {
  runApp(KatalogUygulamasi());
}

class KatalogUygulamasi extends StatefulWidget {
  @override
  _KatalogUygulamasiState createState() => _KatalogUygulamasiState();
}

class _KatalogUygulamasiState extends State<KatalogUygulamasi> {
  final List<Product> _cartItems = [];
  void _addToCart(Product product) {
    setState(() {
      _cartItems.add(product);
    });
    print("Ürün Eklendi: ${product.name}. Sepet Sayısı: ${_cartItems.length}");
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cartItems.remove(product);
    });
    print("Ürün Çıkarıldı: ${product.name}. Sepet Sayısı: ${_cartItems.length}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Katalog Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: DiscoverScreen(
        cartItems: _cartItems,
        onAddToCart: _addToCart,
        onRemoveFromCart: _removeFromCart,
      ),
    );
  }
}