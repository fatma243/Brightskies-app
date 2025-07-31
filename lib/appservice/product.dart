import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Product {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final List<String> images;

  @HiveField(5)
  final String? categoryName;

  @HiveField(6)
  final String? selectedSize;

  @HiveField(7)
  final String? selectedColorName;

  @HiveField(8)
  final int? categoryId;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    this.categoryName,
    this.selectedSize,
    this.selectedColorName,
    this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    title: json['title'],
    price: (json['price'] as num).toDouble(),
    description: json['description'],
    images: List<String>.from(json['images'] ?? []),
    categoryName: json['category']?['name'],
    categoryId: json['category']?['id'],
    selectedSize: json['selectedSize'],
    selectedColorName: json['selectedColorName'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'images': images,
    'category': {
      'id': categoryId,
      'name': categoryName,
    },
    'selectedSize': selectedSize,
    'selectedColorName': selectedColorName,
  };
}

@HiveType(typeId: 1)
@JsonSerializable()
class Category {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
  };
}
