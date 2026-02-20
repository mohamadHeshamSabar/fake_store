import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';

class RatingBadge extends StatelessWidget {
  final Rating rating;

  const RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
          const SizedBox(width: 4),
          Text(
            '${rating.rate}',
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14),
          ),
          Text(
            ' (${rating.count})',
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
