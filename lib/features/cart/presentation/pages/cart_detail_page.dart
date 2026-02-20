import 'package:ecommerce_app/features/cart/presentation/widgets/cart_info_card.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_product_row.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/detail_action_buttons.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/edit_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/cart_model.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartDetailPage extends StatefulWidget {
  final CartModel cart;

  const CartDetailPage({super.key, required this.cart});

  @override
  State<CartDetailPage> createState() => _CartDetailPageState();
}

class _CartDetailPageState extends State<CartDetailPage> {
  @override
  void initState() {
    super.initState();
    // GET /carts/{id}
    context.read<CartCubit>().getCartById(widget.cart.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Cart #${widget.cart.id}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined, color: Colors.orange),
            onPressed: () => _openEdit(context, widget.cart),
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline, color: AppTheme.accent),
            onPressed: () => _showDeleteConfirm(context),
          ),
        ],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(12),
            ));
            if (state.message.contains('deleted')) Navigator.pop(context);
          }
          if (state is CartFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.failure.errorMessage),
              backgroundColor: AppTheme.accent,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.primary));
          }

          final cart = (state is CartLoaded && state.selectedCart != null)
              ? state.selectedCart!
              : widget.cart;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CartInfoCard(cart: cart),
                const SizedBox(height: 20),
                const Text(
                  'Products',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 12),
                if (cart.products.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'No products in this cart',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  )
                else
                  ...cart.products.map(
                    (p) => CartProductRow(product: p),
                  ),
                const SizedBox(height: 28),
                DetailActionButtons(cart: cart),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openEdit(BuildContext context, CartModel cart) {
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
        content: Text('Delete Cart #${widget.cart.id}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            onPressed: () {
              Navigator.pop(context);
              context.read<CartCubit>().deleteCart(widget.cart.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
