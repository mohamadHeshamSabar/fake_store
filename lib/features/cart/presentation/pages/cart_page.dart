import 'package:ecommerce_app/features/cart/presentation/widgets/api_carts_tab.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/local_cart_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<CartCubit>().getAllCarts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: const [
            Tab(text: 'My Cart'),
            Tab(text: 'API Carts'),
          ],
        ),
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
          }
          if (state is CartFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.failure.errorMessage),
              backgroundColor: AppTheme.accent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(12),
            ));
          }
        },
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              LocalCartTab(state: state),
              ApiCartsTab(state: state),
            ],
          );
        },
      ),
    );
  }
}

// ─── Data holder for editable product rows ───────────────────────────────────

class EditableProduct {
  final TextEditingController productIdCtrl;
  final TextEditingController quantityCtrl;

  EditableProduct({
    required this.productIdCtrl,
    required this.quantityCtrl,
  });
}
