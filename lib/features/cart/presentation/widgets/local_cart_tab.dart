import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_list_header.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/order_summary.dart';
import 'package:flutter/material.dart';

class LocalCartTab extends StatelessWidget {
  final CartState state;

  const LocalCartTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final loaded = state is CartLoaded ? state as CartLoaded : null;
    final items = loaded?.localItems ?? [];

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined,
                size: 80, color: AppTheme.textSecondary.withOpacity(0.4)),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            const Text('Add some items to get started',
                style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        CartListHeader(itemCount: items.length),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: items.length,
            itemBuilder: (_, i) => CartItemTile(item: items[i]),
          ),
        ),
        OrderSummary(loaded: loaded!),
      ],
    );
  }
}
