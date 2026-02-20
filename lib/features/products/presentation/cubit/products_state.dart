import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';
import '../../../../core/const/failure.dart';

abstract class ProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

// All products loaded with filter/search support
class ProductsLoaded extends ProductsState {
  final List<Product> allProducts;
  final List<Product> displayedProducts;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;

  ProductsLoaded({
    required this.allProducts,
    required this.displayedProducts,
    required this.categories,
    this.selectedCategory,
    this.searchQuery = '',
  });

  ProductsLoaded copyWith({
    List<Product>? allProducts,
    List<Product>? displayedProducts,
    List<String>? categories,
    String? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
  }) =>
      ProductsLoaded(
        allProducts: allProducts ?? this.allProducts,
        displayedProducts: displayedProducts ?? this.displayedProducts,
        categories: categories ?? this.categories,
        selectedCategory:
            clearCategory ? null : (selectedCategory ?? this.selectedCategory),
        searchQuery: searchQuery ?? this.searchQuery,
      );

  @override
  List<Object?> get props =>
      [allProducts, displayedProducts, categories, selectedCategory, searchQuery];
}

// Single product detail loaded
class ProductDetailLoaded extends ProductsState {
  final Product product;
  ProductDetailLoaded(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductsFailure extends ProductsState {
  final Failure failure;
  ProductsFailure(this.failure);
  @override
  List<Object?> get props => [failure];
}
