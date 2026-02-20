import 'package:badges/badges.dart' as badges;
import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecommerce_app/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ShopEase',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              const Text(
                'Find your perfect item',
                style:
                    TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          BlocBuilder<CartCubit, CartState>(
            builder: (_, state) {
              final count =
                  state is CartLoaded ? state.totalQuantity : 0;
              return badges.Badge(
                badgeContent: Text(
                  '$count',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 10),
                ),
                showBadge: count > 0,
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: AppTheme.accent,
                  padding: EdgeInsets.all(5),
                ),
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CartPage()),
                  ),
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 28,
                    color: AppTheme.textPrimary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
