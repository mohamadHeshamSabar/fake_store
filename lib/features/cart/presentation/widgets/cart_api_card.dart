import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/cart/data/models/cart_model.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/pages/cart_detail_page.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_action_button.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/edit_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartApiCard extends StatelessWidget {
  final CartModel cart;

  const CartApiCard({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          // Tappable header
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            onTap: () => _openDetail(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shopping_cart_outlined,
                        color: AppTheme.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cart #${cart.id}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'User ${cart.userId}  ·  ${cart.products.length} product(s)  ·  ${cart.date}',
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppTheme.textSecondary),
                ],
              ),
            ),
          ),
          // Action buttons
          Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade100))),
            child: Row(
              children: [
                CartActionButton(
                  icon: Icons.visibility_outlined,
                  label: 'View',
                  color: AppTheme.primary,
                  onTap: () {
                    context.read<CartCubit>().getCartById(cart.id);
                    _openDetail(context);
                  },
                ),
                const VerticalDivider(),
                CartActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: Colors.orange,
                  onTap: () => _openEdit(context),
                ),
                VerticalDivider(),
                CartActionButton(
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  color: AppTheme.accent,
                  onTap: () => _showDeleteConfirm(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CartCubit>(),
          child: CartDetailPage(cart: cart),
        ),
      ),
    );
  }

  void _openEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CartCubit>(),
          child: EditCartPage(cart: cart),
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Cart'),
        content: Text('Delete Cart #${cart.id}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            onPressed: () {
              Navigator.pop(context);
              context.read<CartCubit>().deleteCart(cart.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
