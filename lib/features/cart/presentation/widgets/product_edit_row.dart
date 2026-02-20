import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/core/widgets/app_form_field.dart';
import 'package:ecommerce_app/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter/material.dart';

class ProductEditRow extends StatelessWidget {
  final EditableProduct product;
  final VoidCallback onRemove;

  const ProductEditRow({
    required this.product,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppFormField(
              controller: product.productIdCtrl,
              label: 'Product ID',
              icon: Icons.tag,
              keyboardType: TextInputType.number,
              validator: (v) =>
                  int.tryParse(v ?? '') == null ? 'Invalid' : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AppFormField(
              controller: product.quantityCtrl,
              label: 'Qty',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
              validator: (v) =>
                  int.tryParse(v ?? '') == null ? 'Invalid' : null,
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon:
                const Icon(Icons.remove_circle_outline, color: AppTheme.accent),
          ),
        ],
      ),
    );
  }
}
