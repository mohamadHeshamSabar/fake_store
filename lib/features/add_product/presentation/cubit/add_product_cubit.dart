import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/data/datasources/product_remote_datasource.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/domain/entities/product.dart';
import 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final ProductRemoteDataSource _dataSource;

  AddProductCubit(this._dataSource) : super(AddProductInitial());

  /// POST /products
  Future<void> addProduct(Product product) async {
    emit(AddProductLoading());

    final model = ProductModel.fromEntity(product);
    final result = await _dataSource.addProduct(model);

    result.fold(
      (failure) => emit(AddProductFailure(failure)),
      (newProduct) => emit(AddProductSuccess(newProduct)),
    );
  }
}
