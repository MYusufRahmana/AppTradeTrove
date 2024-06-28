import 'package:flutter/material.dart';
import 'package:tradetrove/models/product.dart';
import 'package:tradetrove/services/product.dart';
import 'package:tradetrove/screens/detail_sellProduct.dart'; // Impor halaman ProductDetailScreen

class FavoriteScreen extends StatefulWidget {
  final String userId;

  const FavoriteScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Stream<List<Product>> _favoriteProductsStream;

  @override
  void initState() {
    super.initState();
    _favoriteProductsStream =
        ProductService.getFavoriteProductsForUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products'),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _favoriteProductsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite products found.'));
          }
          List<Product> favoriteProducts = snapshot.data!;
          return ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              Product product = favoriteProducts[index];
              return ListTile(
                title: Text(product.merk),
                subtitle: Text('Rp${product.harga}'),
                leading: product.urlImage != null
                    ? Image.network(
                        product.urlImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: Icon(Icons.image),
                      ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _removeFromFavorites(product.id!);
                  },
                ),
                onTap: () {
                  _navigateToProductDetail(product); // Panggil method untuk navigasi ke ProductDetailScreen
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _removeFromFavorites(String productId) async {
    await ProductService.removeFavorite(productId, widget.userId);
  }

  void _navigateToProductDetail(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}
