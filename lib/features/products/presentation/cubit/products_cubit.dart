import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/models/product_model.dart';
import '../../domain/entities/product.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRemoteDataSource _dataSource;

  ProductsCubit(this._dataSource) : super(ProductsInitial());

  // ─── GET ALL PRODUCTS ──────────────────────────────────────────────────────
  /// Fetches all products from GET /products
  /// On success → [ProductsLoaded] with category list extracted from products
  /// On failure → [ProductsFailure] with the [Failure] object
  Future<void> getAllProducts() async {
    emit(ProductsLoading());

    final result = await _dataSource.getAllProducts();

    result.fold(
      (failure) => emit(ProductsFailure(failure)),
      (products) {
        // Extract unique categories from the product list
        final categories = products
            .map((p) => p.category)
            .toSet()
            .toList();

        emit(ProductsLoaded(
          allProducts: products,
          displayedProducts: products,
          categories: categories,
        ));
      },
    );
  }

  // ─── GET PRODUCT BY ID ─────────────────────────────────────────────────────
  /// Fetches a single product from GET /products/{id}
  Future<void> getProductById(int id) async {
    emit(ProductsLoading());

    final result = await _dataSource.getProductById(id);

    result.fold(
      (failure) => emit(ProductsFailure(failure)),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }

  // ─── ADD PRODUCT ───────────────────────────────────────────────────────────
  /// Posts a new product to POST /products
  /// Appends it to the displayed list on success
  Future<void> addProduct(Product product) async {
    // keep current state so we can restore the list after adding
    final currentState = state;

    emit(ProductsLoading());

    final model = ProductModel.fromEntity(product);
    final result = await _dataSource.addProduct(model);

    result.fold(
      (failure) => emit(ProductsFailure(failure)),
      (newProduct) {
        if (currentState is ProductsLoaded) {
          final updatedAll = [...currentState.allProducts, newProduct];
          final updatedDisplayed = [...currentState.displayedProducts, newProduct];
          final updatedCategories = updatedAll
              .map((p) => p.category)
              .toSet()
              .toList();

          emit(currentState.copyWith(
            allProducts: updatedAll,
            displayedProducts: updatedDisplayed,
            categories: updatedCategories,
          ));
        } else {
          // If we didn't have a list yet, reload
          getAllProducts();
        }
      },
    );
  }

  // ─── FILTER BY CATEGORY ────────────────────────────────────────────────────
  /// Client-side filter — no API call needed
  void filterByCategory(String? category) {
    if (state is! ProductsLoaded) return;
    final current = state as ProductsLoaded;

    if (category == null) {
      emit(current.copyWith(
        displayedProducts: _applySearch(current.allProducts, current.searchQuery),
        clearCategory: true,
      ));
    } else {
      final filtered = current.allProducts
          .where((p) => p.category == category)
          .toList();
      emit(current.copyWith(
        displayedProducts: _applySearch(filtered, current.searchQuery),
        selectedCategory: category,
      ));
    }
  }

  // ─── SEARCH ────────────────────────────────────────────────────────────────
  /// Client-side search — no API call needed
  void search(String query) {
    if (state is! ProductsLoaded) return;
    final current = state as ProductsLoaded;

    final source = current.selectedCategory == null
        ? current.allProducts
        : current.allProducts
            .where((p) => p.category == current.selectedCategory)
            .toList();

    emit(current.copyWith(
      displayedProducts: _applySearch(source, query),
      searchQuery: query,
    ));
  }

  List<Product> _applySearch(List<Product> products, String query) {
    if (query.isEmpty) return products;
    return products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
