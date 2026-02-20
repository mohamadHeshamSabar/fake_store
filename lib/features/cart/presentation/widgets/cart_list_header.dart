import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartListHeader extends StatelessWidget {
  final int itemCount;

  const CartListHeader({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$itemCount item(s)',
            style: const TextStyle(
                color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
          ),
          TextButton.icon(
            onPressed: () => _showClearConfirm(context),
            icon: const Icon(Icons.delete_sweep_outlined,
                color: AppTheme.accent, size: 18),
            label: const Text('Clear All',
                style: TextStyle(color: AppTheme.accent)),
          ),
        ],
      ),
    );
  }

  void _showClearConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            onPressed: () {
              context.read<CartCubit>().clearLocalCart();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
