import 'package:equatable/equatable.dart';

class CartProductModel extends Equatable {
  final int productId;
  final int quantity;

  const CartProductModel({required this.productId, required this.quantity});

  factory CartProductModel.fromJson(Map<String, dynamic> json) =>
      CartProductModel(
        productId: json['productId'] as int,
        quantity: json['quantity'] as int,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
      };

  @override
  List<Object?> get props => [productId, quantity];
}

class CartModel extends Equatable {
  final int id;
  final int userId;
  final String date;
  final List<CartProductModel> products;

  const CartModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json['id'] as int? ?? 0,
        userId: json['userId'] as int? ?? 0,
        date: json['date'] as String? ?? '',
        products: (json['products'] as List? ?? [])
            .map((e) =>
                CartProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'date': date,
        'products': products.map((p) => p.toJson()).toList(),
      };

  @override
  List<Object?> get props => [id, userId, date, products];
}
