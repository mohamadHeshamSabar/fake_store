import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/products/presentation/cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const HomeSearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: TextField(
        controller: controller,
        onChanged: (q) => context.read<ProductsCubit>().search(q),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: const TextStyle(
              color: AppTheme.textSecondary, fontSize: 14),
          prefixIcon:
              const Icon(Icons.search, color: AppTheme.textSecondary),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear,
                      color: AppTheme.textSecondary),
                  onPressed: () {
                    controller.clear();
                    context.read<ProductsCubit>().search('');
                  },
                )
              : null,
        ),
      ),
    );
  }
}
