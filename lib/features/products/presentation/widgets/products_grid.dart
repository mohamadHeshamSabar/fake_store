import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/products/presentation/cubit/products_cubit.dart';
import 'package:ecommerce_app/features/products/presentation/cubit/products_state.dart';
import 'package:ecommerce_app/features/products/presentation/pages/product_detail_page.dart';
import 'package:ecommerce_app/features/products/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/features/products/presentation/widgets/shimmer_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (_, state) {
        if (state is ProductsLoading) return const ShimmerGrid();

        if (state is ProductsFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded,
                    size: 56, color: AppTheme.textSecondary),
                const SizedBox(height: 12),
                Text(
                  state.failure.errorMessage,
                  style: const TextStyle(
                      color: AppTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.read<ProductsCubit>().getAllProducts(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ProductsLoaded) {
          if (state.displayedProducts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 56, color: AppTheme.textSecondary),
                  SizedBox(height: 12),
                  Text(
                    'No products found',
                    style: TextStyle(
                        color: AppTheme.textSecondary, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemCount: state.displayedProducts.length,
            itemBuilder: (_, i) {
              final product = state.displayedProducts[i];
              return ProductCard(
                product: product,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProductDetailPage(product: product),
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
