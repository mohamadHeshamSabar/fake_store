import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/cart/data/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartProductRow extends StatelessWidget {
  final CartProductModel product;

  const CartProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#${product.productId}',
                style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Product ID: ${product.productId}',
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Qty: ${product.quantity}',
              style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
