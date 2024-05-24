import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradetrove/services/product.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  _UploadProductScreenState createState() => _UploadProductScreenState();
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product'),
      ),
      body: SingleChildScrollView(
         padding: const EdgeInsets.all(16.0),
        child: Padding(
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
                keyboardType: TextInputType.number,
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
                decoration: InputDecoration(labelText: 'Harga'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _pickImage,
                child:
                    Text(_imageFile == null ? 'Pick Image' : 'Image Selected'),
              ),
              SizedBox(height: 5.0),
              _imageFile != null ? Image.network((_imageFile!.path)) : Container(),
              ElevatedButton(
                onPressed: () {
                  _uploadProduct();
                },
                child: Text('Upload Product'),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  void _uploadProduct() async {
    if (_merkController.text.isEmpty ||
        _tahunController.text.isEmpty ||
        _jarakTempuhController.text.isEmpty ||
        _bahanBakarController.text.isEmpty ||
        _warnaController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _kapasitasMesinController.text.isEmpty ||
        _tipePenjualController.text.isEmpty ||
        _hargaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    try {
      final uid = 'uid';
      await ProductService().createProduct(
        uid: uid,
        merk: _merkController.text,
        tahun: _tahunController.text,
        jarakTempuh: _jarakTempuhController.text,
        bahanBakar: _bahanBakarController.text,
        warna: _warnaController.text,
        description: _descriptionController.text,
        kapasitasMesin: _kapasitasMesinController.text,
        tipePenjual: _tipePenjualController.text,
        harga: _hargaController.text,
        imageFile: _imageFile,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product uploaded successfully')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload product')),
      );
    }
  }

}
