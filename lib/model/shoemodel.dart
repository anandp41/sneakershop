class ShoeModel {
  final String shoeId;

  final String name;

  List<String> imagePath;

  final double price;

  final String brand;

  final List<Map<String, int>> availableSizesandStock;

  final bool isNew;

  String? description;
  ShoeModel(
      {required this.shoeId,
      required this.name,
      this.imagePath = const [],
      required this.price,
      required this.brand,
      required this.availableSizesandStock,
      required this.isNew,
      this.description});

  Map<String, dynamic> toMap() {
    return {
      'shoeId': shoeId,
      'name': name,
      'imagePath': imagePath,
      'price': price,
      'brand': brand,
      'availableSizesandStock': availableSizesandStock,
      'isNew': isNew,
      'description': description,
    };
  }

  factory ShoeModel.fromMap(Map<String, dynamic> map) {
    return ShoeModel(
      shoeId: map['shoeId'],
      name: map['name'] ?? '',
      imagePath: List<String>.from(map['imagePath']),
      price: map['price']?.toDouble() ?? 0.0,
      brand: map['brand'] ?? '',
      availableSizesandStock: (map['availableSizesandStock'] as List)
          .map((item) => Map<String, int>.from(item))
          .toList(),
      isNew: map['isNew'] ?? false,
      description: map['description'],
    );
  }
}
