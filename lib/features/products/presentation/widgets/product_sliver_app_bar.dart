import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductSliverAppBar extends StatelessWidget {
  final Product product;

  const ProductSliverAppBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: const Color(0xFFF5F5F5),
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: AppTheme.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product-${product.id}',
          child: Container(
            color: const Color(0xFFF5F5F5),
            padding: const EdgeInsets.all(40),
            child: CachedNetworkImage(
              imageUrl: product.image,
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 60),
            ),
          ),
        ),
      ),
    );
  }
}
