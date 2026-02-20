import '../../domain/entities/product.dart';

class RatingModel extends Rating {
  const RatingModel({required super.rate, required super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        rate: (json['rate'] as num).toDouble(),
        count: json['count'] as int,
      );

  Map<String, dynamic> toJson() => {'rate': rate, 'count': count};
}

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as int? ?? 0,
        title: json['title'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        description: json['description'] as String? ?? '',
        category: json['category'] as String? ?? '',
        image: json['image'] as String? ?? '',
        rating: json['rating'] != null
            ? RatingModel.fromJson(json['rating'] as Map<String, dynamic>)
            : const RatingModel(rate: 0, count: 0),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        // Always convert to RatingModel safely — rating may be a plain Rating
        'rating': _ratingToJson(rating),
      };

  static Map<String, dynamic> _ratingToJson(Rating rating) {
    if (rating is RatingModel) return rating.toJson();
    return {'rate': rating.rate, 'count': rating.count};
  }

  static ProductModel fromEntity(Product product) => ProductModel(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
        // Always wrap in RatingModel so toJson() always works
        rating: product.rating is RatingModel
            ? product.rating
            : RatingModel(
                rate: product.rating.rate,
                count: product.rating.count,
              ),
      );
}
