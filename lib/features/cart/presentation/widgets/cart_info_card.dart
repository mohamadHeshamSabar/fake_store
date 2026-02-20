import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/cart/data/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartInfoCard extends StatelessWidget {
  final CartModel cart;

  const CartInfoCard({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                color: AppTheme.primary, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            'Cart #${cart.id}',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 16),
          _CartInfoRow(
            icon: Icons.person_outline,
            label: 'User ID',
            value: '${cart.userId}',
          ),
          const SizedBox(height: 8),
          _CartInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: cart.date,
          ),
          const SizedBox(height: 8),
          _CartInfoRow(
            icon: Icons.inventory_2_outlined,
            label: 'Products',
            value: '${cart.products.length} item(s)',
          ),
        ],
      ),
    );
  }
}

// ─── Single info row (icon + label + value) ──────────────────────────────────

class _CartInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CartInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              fontSize: 13),
        ),
      ],
    );
  }
}
