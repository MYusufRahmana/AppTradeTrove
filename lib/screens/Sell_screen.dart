import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradetrove/services/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
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
    final PickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        _imageFile = XFile(PickedFile.path);
      });
    }
  }

  void _addProduct() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User tidak ditemukan')),
        );
        return;
      }

      String uid = user.uid;

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
        const SnackBar(content: Text('Produk berhasil ditambahkan')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _merkController,
              decoration: InputDecoration(
                labelText: 'Merk',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _tahunController,
              decoration: InputDecoration(
                labelText: 'Tahun',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _jarakTempuhController,
              decoration: InputDecoration(
                labelText: 'Jarak Tempuh',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _bahanBakarController,
              decoration: InputDecoration(
                labelText: 'Bahan Bakar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _warnaController,
              decoration: InputDecoration(
                labelText: 'Warna',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _kapasitasMesinController,
              decoration: InputDecoration(
                labelText: 'Kapasitas Mesin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _tipePenjualController,
              decoration: InputDecoration(
                labelText: 'Tipe Penjual',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _hargaController,
              decoration: InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            _imageFile != null
                ? Image.network(_imageFile!.path, fit: BoxFit.cover)
                : Container(),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
             const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _addProduct,
                child: const Text('Tambah Produk'),
              )
            ),
          ],
        ),
      ),
    );
  }
}
