import 'package:equatable/equatable.dart';
import '../../../../core/const/failure.dart';
import '../../../cart/data/models/cart_model.dart';
import '../../../products/domain/entities/product.dart';

// ─── Local cart item (what the user sees in UI) ─────────────────────────────

class LocalCartItem extends Equatable {
  final Product product;
  final int quantity;

  const LocalCartItem({required this.product, required this.quantity});

  LocalCartItem copyWith({int? quantity}) =>
      LocalCartItem(product: product, quantity: quantity ?? this.quantity);

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}

// ─── States ──────────────────────────────────────────────────────────────────

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

/// Holds both the local UI cart AND the API cart list
class CartLoaded extends CartState {
  /// Items the user added locally (from product detail page)
  final List<LocalCartItem> localItems;

  /// All carts fetched from GET /carts
  final List<CartModel> remoteCarts;

  /// Currently selected cart detail (GET /carts/{id})
  final CartModel? selectedCart;

  CartLoaded({
    this.localItems = const [],
    this.remoteCarts = const [],
    this.selectedCart,
  });

  double get totalPrice =>
      localItems.fold(0, (sum, i) => sum + i.totalPrice);

  int get totalQuantity =>
      localItems.fold(0, (sum, i) => sum + i.quantity);

  CartLoaded copyWith({
    List<LocalCartItem>? localItems,
    List<CartModel>? remoteCarts,
    CartModel? selectedCart,
    bool clearSelectedCart = false,
  }) =>
      CartLoaded(
        localItems: localItems ?? this.localItems,
        remoteCarts: remoteCarts ?? this.remoteCarts,
        selectedCart:
            clearSelectedCart ? null : (selectedCart ?? this.selectedCart),
      );

  @override
  List<Object?> get props => [localItems, remoteCarts, selectedCart];
}

class CartFailure extends CartState {
  final Failure failure;
  CartFailure(this.failure);
  @override
  List<Object?> get props => [failure];
}

class CartOperationSuccess extends CartState {
  final String message;
  final CartModel? cart;
  CartOperationSuccess({required this.message, this.cart});
  @override
  List<Object?> get props => [message, cart];
}
