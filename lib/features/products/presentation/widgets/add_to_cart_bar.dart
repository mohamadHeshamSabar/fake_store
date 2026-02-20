import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddToCartBar extends StatelessWidget {
  final Product product;

  const AddToCartBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final inCart = state is CartLoaded &&
              state.localItems.any((i) => i.product.id == product.id);

          return ElevatedButton.icon(
            onPressed: () {
              context.read<CartCubit>().addToLocalCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added to cart!'),
                  backgroundColor: AppTheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(12),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
              backgroundColor:
                  inCart ? AppTheme.accent : AppTheme.primary,
            ),
            icon: Icon(
              inCart ? Icons.shopping_bag : Icons.add_shopping_cart,
            ),
            label: Text(
              inCart ? 'In Cart — Add More' : 'Add to Cart',
            ),
          );
        },
      ),
    );
  }
}
