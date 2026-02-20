import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onChanged;

  const CategorySelector({
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((cat) {
        final isSelected = selected == cat;
        return ChoiceChip(
          label: Text(_capitalize(cat)),
          selected: isSelected,
          onSelected: (_) => onChanged(cat),
          selectedColor: AppTheme.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? AppTheme.primary : Colors.grey.shade200,
          ),
        );
      }).toList(),
    );
  }
}
