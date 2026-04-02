import 'package:flutter/material.dart';
import '../models/products.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class DiscoverScreen extends StatefulWidget {
  final List<Product> cartItems;
  final Function(Product) onAddToCart;
  final Function(Product) onRemoveFromCart;

  DiscoverScreen({required this.cartItems, required this.onAddToCart, required this.onRemoveFromCart});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late Future<List<Product>> futureProducts;
  List<Product>? allProducts;
  List<Product>? displayedProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  void _filterProducts(String query) {
    if (allProducts != null) {
      setState(() {
        displayedProducts = allProducts!
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Discover", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28)),
        actions: [
          IconButton(
            icon: Stack(children: [
              Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 30),
              if (widget.cartItems.isNotEmpty)
                Positioned(right: 0, child: CircleAvatar(radius: 8, backgroundColor: Colors.red, child: Text("${widget.cartItems.length}", style: TextStyle(fontSize: 10, color: Colors.white)))),
            ]),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => CartScreen(cartItems: widget.cartItems, onRemove: widget.onRemoveFromCart))),
          )
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.black));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error!: Check your internet connection."));
          } else if (snapshot.hasData) {
            allProducts ??= snapshot.data;
            displayedProducts ??= snapshot.data;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      onChanged: _filterProducts,
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 15, mainAxisSpacing: 15),
                    itemCount: displayedProducts!.length,
                    itemBuilder: (context, index) {
                      final product = displayedProducts![index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ProductDetailScreen(product: product, onAddToCart: widget.onAddToCart))),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Expanded(child: Padding(padding: EdgeInsets.all(10), child: Image.network(product.image))),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Text(product.name, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    Text(product.price, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}