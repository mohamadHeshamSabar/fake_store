import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/cart/data/models/cart_model.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_api_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApiCartsTab extends StatelessWidget {
  final CartState state;

  const ApiCartsTab({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is CartLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppTheme.primary));
    }

    final carts =
        state is CartLoaded ? (state as CartLoaded).remoteCarts : <CartModel>[];

    if (carts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 64, color: AppTheme.textSecondary.withOpacity(0.4)),
            const SizedBox(height: 16),
            const Text('No carts found',
                style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.read<CartCubit>().getAllCarts(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reload'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: () => context.read<CartCubit>().getAllCarts(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: carts.length,
        itemBuilder: (_, i) => CartApiCard(cart: carts[i]),
      ),
    );
  }
}
