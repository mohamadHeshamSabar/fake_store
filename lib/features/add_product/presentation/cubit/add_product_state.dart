import 'package:equatable/equatable.dart';
import '../../../../core/const/failure.dart';
import '../../../products/domain/entities/product.dart';

abstract class AddProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {
  final Product product;
  AddProductSuccess(this.product);
  @override
  List<Object?> get props => [product];
}

class AddProductFailure extends AddProductState {
  final Failure failure;
  AddProductFailure(this.failure);
  @override
  List<Object?> get props => [failure];
}
