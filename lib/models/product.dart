class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int quantity;
  bool isFavorite; // Trường đánh dấu yêu thích

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    this.isFavorite = false, // Mặc định là không yêu thích
  });

  // Phương thức từ JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '', // Xử lý nếu _id bị null
      name: json['name'] ?? 'Unnamed Product',
      description: json['description'] ?? 'No description',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? 'placeholder.png',
      quantity: json['quantity'] ?? 0,
      isFavorite: json['isFavorite'] ?? false, // Thêm xử lý yêu thích từ JSON
    );
  }

  // Phương thức chuyển về JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'isFavorite': isFavorite,
    };
  }
}
