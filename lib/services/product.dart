import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradetrove/services/image.dart';

class ProductService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _productCollection = _database.collection('product');

  Future<void> createProduct({
    required String uid,
    required String merk,
    required String tahun,
    required String jarakTempuh,
    required String bahanBakar,
    required String warna,
    required String description,
    required String kapasitasMesin,
    required String tipePenjual,
    required String harga,
    XFile? imageFile,
  }) async {
    try {
      String? urlImage;
      if (imageFile != null) {
        urlImage = await ImageService.uploadImage(imageFile, 'product_images');
      }
      Map<String, dynamic> newProduct = {
        'merk': merk,
        'tahun': tahun,
        'jarakTempuh': jarakTempuh,
        'bahanBakar': bahanBakar,
        'warna': warna,
        'description': description,
        'kapasitasMesin': kapasitasMesin,
        'tipePenjual': tipePenjual,
        'harga': harga,
        'urlImage': urlImage,
      };
      await _productCollection.doc(uid).set(newProduct);
    } catch (e) {
      throw Exception('Gagal menambahkan produk: $e');
    }
  }
}
