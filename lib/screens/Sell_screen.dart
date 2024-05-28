import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradetrove/models/product.dart';
import 'package:tradetrove/services/product.dart';
import 'package:tradetrove/screens/home_screen.dart'; // Ganti dengan path ke HomeScreen Anda

class UploadProductScreen extends StatefulWidget {
  final Product? product;

  const UploadProductScreen({super.key, this.product});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final _merkController = TextEditingController();
  final _tahunController = TextEditingController();
  final _jarakTempuhController = TextEditingController();
  final _bahanBakarController = TextEditingController();
  final _warnaController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _kapasitasMesinController = TextEditingController();
  final _tipePenjualController = TextEditingController();
  final _hargaController = TextEditingController();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _merkController.text = widget.product!.merk;
      _tahunController.text = widget.product!.tahun;
      _jarakTempuhController.text = widget.product!.jarakTempuh;
      _bahanBakarController.text = widget.product!.bahanBakar;
      _warnaController.text = widget.product!.warna;
      _descriptionController.text = widget.product!.description;
      _kapasitasMesinController.text = widget.product!.kapasitasMesin;
      _tipePenjualController.text = widget.product!.tipePenjual;
      _hargaController.text = widget.product!.harga;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  void dispose() {
    _merkController.dispose();
    _tahunController.dispose();
    _jarakTempuhController.dispose();
    _bahanBakarController.dispose();
    _warnaController.dispose();
    _descriptionController.dispose();
    _kapasitasMesinController.dispose();
    _tipePenjualController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _merkController,
              decoration: InputDecoration(labelText: 'Merk'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _tahunController,
               keyboardType: TextInputType
                    .number,
              decoration: InputDecoration(labelText: 'Tahun Mobil'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _jarakTempuhController,
              decoration: InputDecoration(labelText: 'Jarak Tempuh'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _bahanBakarController,
              decoration: InputDecoration(labelText: 'Bahan Bakar'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _warnaController,
              decoration: InputDecoration(labelText: 'Warna'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _kapasitasMesinController,
               keyboardType: TextInputType
                    .number,
              decoration: InputDecoration(labelText: 'Kapasitas Mesin'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _tipePenjualController,
              decoration: InputDecoration(labelText: 'Tipe Penjual'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _hargaController,
               keyboardType: TextInputType
                    .number,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(_imageFile == null ? 'Pick Image' : 'Image Selected'),
            ),
            SizedBox(height: 5.0),
            _imageFile != null
                ? Image.network((_imageFile!.path))
                : Container(),
            ElevatedButton(
              onPressed: () async {
                String? urlImage;
                if (_imageFile != null) {
                  urlImage = await ProductService.uploadImage(_imageFile!, 'list_image_product');
                } else {
                  urlImage = widget.product?.urlImage;
                }
                Product product = Product(
                  id: widget.product?.id,
                  merk: _merkController.text,
                  tahun: _tahunController.text,
                  bahanBakar: _bahanBakarController.text,
                  jarakTempuh: _jarakTempuhController.text,
                  warna: _warnaController.text,
                  description: _descriptionController.text,
                  kapasitasMesin: _kapasitasMesinController.text,
                  tipePenjual: _tipePenjualController.text,
                  harga: _hargaController.text,
                  urlImage: urlImage,
                  createdAt: widget.product?.createdAt,
                );
                try {
                  if (widget.product == null) {
                    await ProductService.addProduct(product);
                  } else {
                    await ProductService.addProduct(product);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product uploaded successfully')),
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreen()), // Ganti dengan path ke HomeScreen Anda
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload product')),
                  );
                }
              },
              child: Text('Upload Product'),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
