class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int  quantity;


  Product({required this.id, required this.name, required this.description, required this.price, required this.imageUrl, required  this.quantity});


  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}
