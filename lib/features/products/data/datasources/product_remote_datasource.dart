import '../../../../core/const/app_variables.dart';
import '../../../../core/const/failure.dart';
import '../../../../core/network/internet_service.dart';
import 'package:dartz/dartz.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final InternetService _service;
  ProductRemoteDataSource(this._service);

  /// GET /products
  Future<Either<Failure, List<ProductModel>>> getAllProducts() {
    return _service.getData<List<ProductModel>>(
      endPoint: AppVariables.productsEndpoint,
      fromJson: (json) => (json as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// GET /products/{id}
  Future<Either<Failure, ProductModel>> getProductById(int id) {
    return _service.getData<ProductModel>(
      endPoint: AppVariables.productByIdEndpoint(id),
      fromJson: (json) => ProductModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /products
  Future<Either<Failure, ProductModel>> addProduct(ProductModel product) {
    return _service.postData<ProductModel>(
      endPoint: AppVariables.productsEndpoint,
      data: product.toJson(),
      fromJson: (json) => ProductModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
