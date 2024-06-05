import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradetrove/models/product.dart';
import 'package:tradetrove/services/location_service.dart';
import 'package:tradetrove/services/product.dart';
import 'package:tradetrove/screens/home_screen.dart'; // Ganti dengan path ke HomeScreen Anda
import 'package:flutter/services.dart';

class UploadProductScreen extends StatefulWidget {
  final Product? product;

  const UploadProductScreen({Key? key, this.product}) : super(key: key);

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
  final _tipePenjualController = TextEditingController(); // Tambahkan controller untuk tipe penjual
  final _hargaController = TextEditingController();
  Position? _position;
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
      _tipePenjualController.text = widget.product!.tipePenjual; // Assign nilai tipe penjual
      _hargaController.text = widget.product!.harga;
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
              keyboardType: TextInputType.number, // Hanya memperbolehkan input angka
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Memastikan hanya angka yang bisa dimasukkan
              decoration: InputDecoration(labelText: 'Tahun Mobil'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _jarakTempuhController,
              keyboardType: TextInputType.number, // Hanya memperbolehkan input angka
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Memastikan hanya angka yang bisa dimasukkan
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
              keyboardType: TextInputType.number, // Hanya memperbolehkan input angka
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Memastikan hanya angka yang bisa dimasukkan
              decoration: InputDecoration(labelText: 'Kapasitas Mesin'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _tipePenjualController, // Menambahkan TextField untuk tipe penjual
              decoration: InputDecoration(labelText: 'Tipe Penjual'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _hargaController,
              keyboardType: TextInputType.number, // Hanya memperbolehkan input angka
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Memastikan hanya angka yang bisa dimasukkan
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(_imageFile == null ? 'Pick Image' : 'Image Selected'),
            ),
            TextButton(
              onPressed: _getLocation,
              child: const Text("Get Location"),
            ),
            Text(
              _position?.latitude != null && _position?.longitude != null
                  ? 'Current Position : ${_position!.latitude.toString()}, ${_position!.longitude.toString()}'
                  : 'Current Position : ${widget.product?.lat}, ${widget.product?.lng}',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5.0),
            _imageFile != null
                ? Image.network((_imageFile!.path))
                : Container(),
            ElevatedButton(
              onPressed: () async {
                String? urlImage;
                if (_imageFile != null) {
                  urlImage = await ProductService.uploadImage(
                      _imageFile!, 'list_image_product');
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
                  tipePenjual: _tipePenjualController.text, // Mengambil nilai dari controller tipe penjual
                  harga: _hargaController.text,
                  urlImage: urlImage,
                  lat: widget.product?.lat.toString() !=
                          _position!.latitude.toString()
                      ? _position!.latitude.toString()
                      : widget.product?.lat.toString(),
                  lng: widget.product?.lng.toString() !=
                          _position!.longitude.toString()
                      ? _position!.longitude.toString()
                      : widget.product?.lng.toString(),
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
                    MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen()), // Ganti dengan path ke HomeScreen Anda
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _getLocation() async {
    final location = await LocationService().getCurrentLocation();
    setState(() {
      _position = location;
    });
  }
}
