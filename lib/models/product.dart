import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  final String merk;
  final String tahun;
  final String jarakTempuh;
  final String bahanBakar;
  final String warna;
  final String description;
  final String kapasitasMesin;
  final String tipePenjual;
  final String harga;
  String? lat;
  String? lng;
  String? urlImage;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? userName;
  String? userId; // Tambahkan ini

  Product({
    this.id,
    required this.merk,
    required this.tahun,
    required this.jarakTempuh,
    required this.bahanBakar,
    required this.warna,
    required this.description,
    required this.kapasitasMesin,
    required this.tipePenjual,
    required this.harga,
    this.urlImage,
    this.lat,
    this.lng,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.userId, // Tambahkan ini
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      merk: data['merk'] ?? '',
      tahun: data['tahun'] ?? '',
      jarakTempuh: data['jarakTempuh'] ?? '',
      bahanBakar: data['bahanBakar'] ?? '',
      warna: data['warna'] ?? '',
      description: data['description'] ?? '',
      kapasitasMesin: data['kapasitasMesin'] ?? '',
      tipePenjual: data['tipePenjual'] ?? '',
      harga: data['harga'] ?? '',
      urlImage: data['urlImage'],
      lat: data['lat'],
      lng: data['lng'],
      userName: data['userName'],
      userId: data['userId'], // Tambahkan ini
      createdAt: data['created_at'] as Timestamp?,
      updatedAt: data['updated_at'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
      'lat': lat,
      'lng': lng,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'userName': userName,
      'userId': userId, // Tambahkan ini
    };
  }
}
