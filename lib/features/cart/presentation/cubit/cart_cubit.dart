import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/cart_remote_datasource.dart';
import '../../data/models/cart_model.dart';
import '../../../products/domain/entities/product.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRemoteDataSource _dataSource;

  CartCubit(this._dataSource) : super(CartLoaded());

  CartLoaded get _current =>
      state is CartLoaded ? state as CartLoaded : CartLoaded();

  // ═══════════════════════════════════════════════════════════════════════════
  // LOCAL CART (UI — product detail → cart page)
  // ═══════════════════════════════════════════════════════════════════════════

  void addToLocalCart(Product product) {
    final items = List<LocalCartItem>.from(_current.localItems);
    final idx = items.indexWhere((i) => i.product.id == product.id);

    if (idx >= 0) {
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity + 1);
    } else {
      items.add(LocalCartItem(product: product, quantity: 1));
    }
    emit(_current.copyWith(localItems: items));
  }

  void increaseQuantity(int productId) {
    final items = List<LocalCartItem>.from(_current.localItems);
    final idx = items.indexWhere((i) => i.product.id == productId);
    if (idx < 0) return;
    items[idx] = items[idx].copyWith(quantity: items[idx].quantity + 1);
    emit(_current.copyWith(localItems: items));
  }

  void decreaseQuantity(int productId) {
    final items = List<LocalCartItem>.from(_current.localItems);
    final idx = items.indexWhere((i) => i.product.id == productId);
    if (idx < 0) return;
    if (items[idx].quantity == 1) {
      items.removeAt(idx);
    } else {
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity - 1);
    }
    emit(_current.copyWith(localItems: items));
  }

  void removeFromLocalCart(int productId) {
    final items = _current.localItems
        .where((i) => i.product.id != productId)
        .toList();
    emit(_current.copyWith(localItems: items));
  }

  void clearLocalCart() {
    emit(_current.copyWith(localItems: []));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REMOTE CART API
  // ═══════════════════════════════════════════════════════════════════════════

  /// GET /carts — fetch all carts from the API
  Future<void> getAllCarts() async {
    final saved = _current;
    emit(CartLoading());

    final result = await _dataSource.getAllCarts();

    result.fold(
      (failure) => emit(CartFailure(failure)),
      (carts) => emit(saved.copyWith(remoteCarts: carts)),
    );
  }

  /// GET /carts/{id} — fetch cart details
  Future<void> getCartById(int id) async {
    final saved = _current;
    emit(CartLoading());

    final result = await _dataSource.getCartById(id);

    result.fold(
      (failure) => emit(CartFailure(failure)),
      (cart) => emit(saved.copyWith(selectedCart: cart)),
    );
  }

  /// POST /carts — add a new cart to the API
  /// Typically called when the user presses "checkout" or "sync cart"
  Future<void> addCartToApi({
    required int userId,
    required List<CartProductModel> products,
  }) async {
    final saved = _current;
    emit(CartLoading());

    final cart = CartModel(
      id: 0,
      userId: userId,
      date: DateTime.now().toIso8601String().split('T').first,
      products: products,
    );

    final result = await _dataSource.addCart(cart);

    result.fold(
      (failure) => emit(CartFailure(failure)),
      (newCart) {
        final updated = [...saved.remoteCarts, newCart];
        emit(CartOperationSuccess(
          message: 'Cart created successfully',
          cart: newCart,
        ));
        // Restore local items + updated remote list
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(saved.copyWith(remoteCarts: updated, selectedCart: newCart));
        });
      },
    );
  }

  /// PUT /carts/{id} — update an existing cart
  Future<void> updateCart(int id, CartModel updatedCart) async {
    final saved = _current;
    emit(CartLoading());

    final result = await _dataSource.updateCart(id, updatedCart);

    result.fold(
      (failure) => emit(CartFailure(failure)),
      (cart) {
        final updatedList = saved.remoteCarts
            .map((c) => c.id == id ? cart : c)
            .toList();
        emit(CartOperationSuccess(
          message: 'Cart updated successfully',
          cart: cart,
        ));
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(saved.copyWith(remoteCarts: updatedList, selectedCart: cart));
        });
      },
    );
  }

  /// DELETE /carts/{id} — delete a cart
  Future<void> deleteCart(int id) async {
    final saved = _current;
    emit(CartLoading());

    final result = await _dataSource.deleteCart(id);

    result.fold(
      (failure) => emit(CartFailure(failure)),
      (_) {
        final updatedList =
            saved.remoteCarts.where((c) => c.id != id).toList();
        emit(CartOperationSuccess(message: 'Cart deleted successfully'));
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(saved.copyWith(
            remoteCarts: updatedList,
            clearSelectedCart: true,
          ));
        });
      },
    );
  }
}
