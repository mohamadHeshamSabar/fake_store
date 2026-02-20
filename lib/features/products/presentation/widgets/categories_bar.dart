import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/products/presentation/cubit/products_cubit.dart';
import 'package:ecommerce_app/features/products/presentation/cubit/products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesBar extends StatelessWidget {
  const CategoriesBar();

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (_, state) {
        if (state is! ProductsLoaded) return const SizedBox.shrink();

        final categories = ['All', ...state.categories];

        return SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final isAll = cat == 'All';
              final isSelected = isAll
                  ? state.selectedCategory == null
                  : state.selectedCategory == cat;

              return ChoiceChip(
                label: Text(
                  _capitalize(cat),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => context
                    .read<ProductsCubit>()
                    .filterByCategory(isAll ? null : cat),
                selectedColor: AppTheme.primary,
                backgroundColor: AppTheme.surface,
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.primary
                      : Colors.grey.shade200,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
