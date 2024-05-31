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
    required this.urlImage,
    this.lat,
    this.lng,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      merk: data['merk'] ?? '',
      tahun: data['tahun'] ?? '',
      jarakTempuh: data['jarakTempuh'] ?? '',
      bahanBakar: data['bahanBakar'] ?? '',
      warna: data['warna'] ?? '',
      description: data['description'] ?? '',
      kapasitasMesin: data['kapasitasMesin'] ?? '',
      tipePenjual: data['tipePenjual'] ?? '',
      harga: data['harga'] ?? '',
      urlImage: data['urlImage'] ?? '',
      lat: data['lat'],
      lng: data['lng'],
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'merk': merk,
      'tahun': tahun,
      'tittle': jarakTempuh,
      'bahanBakar': bahanBakar,
      'warna': warna,
      'description': description,
      'kapasitasMesin': kapasitasMesin,
      'tipePenjual': tipePenjual,
      'harga': harga,
      'urlimage': urlImage,
      'lat': lat,
      'lng': lng,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Favorite {
  final String userId;

  Favorite({
    required this.userId,
  });

  factory Favorite.fromMap(Map<String, dynamic> data) {
    return Favorite(
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
    };
  }
}