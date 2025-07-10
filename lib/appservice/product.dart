class Product {
  final String id;
  final String imagePath;
  final String title;
  final double price;
  final String description;
  final String location;
  final double rating;
  final List<String> features;

  Product({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.description,
    required this.location,
    required this.rating,
    required this.features,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      imagePath: json['imagePath'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      location: json['location'],
      rating: (json['rating'] as num).toDouble(),
      features: List<String>.from(json['features']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'price': price,
      'description': description,
      'location': location,
      'rating': rating,
      'features': features,
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is Product) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

}