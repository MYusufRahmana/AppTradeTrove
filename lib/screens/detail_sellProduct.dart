import 'package:flutter/material.dart';
import 'package:tradetrove/models/product.dart';
import 'package:tradetrove/services/product.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (product.urlImage != null &&
                Uri.parse(product.urlImage!).isAbsolute)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  product.urlImage!,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ListTile(
              title: Text(
                product.merk,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp${product.harga}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Tahun: ${product.tahun}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/bahanBakar.png',
                        width: 25,
                        height: 25,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${product.bahanBakar}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 20),
                      Image.asset(
                        'assets/images/jarakTempuh.png',
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${product.jarakTempuh}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          _openMap(product.lat, product.lng);
                        },
                        icon: Image.asset(
                          'assets/images/lokasi.png', // Ganti dengan path gambar ikon kustom Anda
                          width: 50,
                          height: 50,
                        ),
                        tooltip: 'Open Location',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Tambahkan logika yang sesuai di sini
              },
              icon: Image.asset(
                'assets/images/chatIcon.png',
                width: 24,
                height: 24,
              ),
              label: Text('Chat Penjual'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context);
              },
              child: const Text('Delete Product'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMap(String? lat, String? lng) async {
    final Uri uri =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    // set up the buttons
    final Widget cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("No"),
    );
    final Widget continueButton = ElevatedButton(
      onPressed: () {
        ProductService.deleteProduct(product).whenComplete(() {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      },
      child: const Text("Yes"),
    );

    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      title: const Text("Delete Product"),
      content: const Text("Are you sure you want to delete this product?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
