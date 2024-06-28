class Favorite {
  final String productId;
  final String userId;

  Favorite({
    required this.productId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': userId,
    };
  }
}
