import 'package:dartz/dartz.dart';
import '../../../../core/const/app_variables.dart';
import '../../../../core/const/failure.dart';
import '../../../../core/network/internet_service.dart';
import '../models/cart_model.dart';

class CartRemoteDataSource {
  final InternetService _service;
  CartRemoteDataSource(this._service);

  /// GET /carts → all carts
  Future<Either<Failure, List<CartModel>>> getAllCarts() {
    return _service.getData<List<CartModel>>(
      endPoint: AppVariables.cartsEndpoint,
      fromJson: (json) => (json as List)
          .map((e) => CartModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// GET /carts/{id} → single cart details
  Future<Either<Failure, CartModel>> getCartById(int id) {
    return _service.getData<CartModel>(
      endPoint: AppVariables.cartByIdEndpoint(id),
      fromJson: (json) => CartModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /carts → add a new cart
  Future<Either<Failure, CartModel>> addCart(CartModel cart) {
    return _service.postData<CartModel>(
      endPoint: AppVariables.cartsEndpoint,
      data: cart.toJson(),
      fromJson: (json) => CartModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// PUT /carts/{id} → update an existing cart
  Future<Either<Failure, CartModel>> updateCart(int id, CartModel cart) {
    return _service.putData<CartModel>(
      endPoint: AppVariables.cartByIdEndpoint(id),
      data: cart.toJson(),
      fromJson: (json) => CartModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// DELETE /carts/{id} → delete a cart
  Future<Either<Failure, CartModel>> deleteCart(int id) {
    return _service.deleteData<CartModel>(
      endPoint: AppVariables.cartByIdEndpoint(id),
      fromJson: (json) => CartModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
