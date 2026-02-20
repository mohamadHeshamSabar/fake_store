import 'package:ecommerce_app/features/products/presentation/widgets/add_to_cart_bar.dart';
import 'package:ecommerce_app/features/products/presentation/widgets/product_content.dart';
import 'package:ecommerce_app/features/products/presentation/widgets/product_sliver_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          ProductSliverAppBar(product: product),
          SliverToBoxAdapter(
            child: ProductContent(product: product),
          ),
        ],
      ),
      bottomNavigationBar: AddToCartBar(product: product),
    );
  }
}
