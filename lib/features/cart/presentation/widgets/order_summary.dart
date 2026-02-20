import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/core/widgets/section_label.dart';
import 'package:ecommerce_app/features/cart/data/models/cart_model.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/summary_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderSummary extends StatelessWidget {
  final CartLoaded loaded;

  const OrderSummary({required this.loaded});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Order Summary'),
          const SizedBox(height: 12),
          SummaryRow(
            label: '${loaded.totalQuantity} items',
            value: '\$${loaded.totalPrice.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 6),
          const SummaryRow(
            label: 'Shipping',
            value: 'Free',
            valueColor: Colors.green,
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppTheme.textPrimary),
              ),
              Text(
                '\$${loaded.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: AppTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _checkout(context),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54)),
            child: const Text('Checkout → Sync to API'),
          ),
        ],
      ),
    );
  }

  void _checkout(BuildContext context) {
    final apiProducts = loaded.localItems
        .map((i) => CartProductModel(
              productId: i.product.id,
              quantity: i.quantity,
            ))
        .toList();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.cloud_upload_outlined, color: AppTheme.primary),
          SizedBox(width: 8),
          Text('Sync Cart to API?'),
        ]),
        content: Text(
            'This will POST your ${loaded.localItems.length} item(s) to the FakeStore API as a new cart.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<CartCubit>().addCartToApi(
                    userId: 1,
                    products: apiProducts,
                  );
            },
            child: const Text('Sync'),
          ),
        ],
      ),
    );
  }
}
