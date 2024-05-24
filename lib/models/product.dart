class product {
  final String merk;
  final String tahun;
  final int jarakTempuh;
  final String bahanBakar;
  final String warna;
  final String description;
  final String kapasitasMesin;
  final String tipePenjual;
  final int    harga;
    final String urlImage;

  product({
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
  });

  factory product.fromMap(Map<String, dynamic> data, String documentId) {
    return product(
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