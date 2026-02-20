import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/core/widgets/app_form_field.dart';
import 'package:ecommerce_app/core/widgets/section_label.dart';
import 'package:ecommerce_app/features/cart/data/models/cart_model.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecommerce_app/features/cart/presentation/pages/cart_page.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/edit_submit_button.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/product_edit_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCartPage extends StatefulWidget {
  final CartModel cart;

  const EditCartPage({super.key, required this.cart});

  @override
  State<EditCartPage> createState() => _EditCartPageState();
}

class _EditCartPageState extends State<EditCartPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _userIdCtrl;
  late final TextEditingController _dateCtrl;
  late List<EditableProduct> _products;

  @override
  void initState() {
    super.initState();
    _userIdCtrl = TextEditingController(text: widget.cart.userId.toString());
    _dateCtrl = TextEditingController(text: widget.cart.date);
    _products = widget.cart.products
        .map((p) => EditableProduct(
              productIdCtrl:
                  TextEditingController(text: p.productId.toString()),
              quantityCtrl: TextEditingController(text: p.quantity.toString()),
            ))
        .toList();
  }

  @override
  void dispose() {
    _userIdCtrl.dispose();
    _dateCtrl.dispose();
    for (final p in _products) {
      p.productIdCtrl.dispose();
      p.quantityCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartOperationSuccess) Navigator.pop(context);
        if (state is CartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.failure.errorMessage),
            backgroundColor: AppTheme.accent,
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text('Edit Cart #${widget.cart.id}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Cart Info'),
                const SizedBox(height: 12),
                AppFormField(
                  controller: _userIdCtrl,
                  label: 'User ID',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      int.tryParse(v ?? '') == null ? 'Invalid ID' : null,
                ),
                const SizedBox(height: 14),
                AppFormField(
                  controller: _dateCtrl,
                  label: 'Date (YYYY-MM-DD)',
                  icon: Icons.calendar_today_outlined,
                  validator: (v) => v?.isEmpty == true ? 'Date required' : null,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionLabel('Products'),
                    TextButton.icon(
                      onPressed: _addProductRow,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  _products.length,
                  (i) => ProductEditRow(
                    product: _products[i],
                    onRemove: () => setState(() => _products.removeAt(i)),
                  ),
                ),
                const SizedBox(height: 24),
                EditSubmitButton(onSubmit: _submit),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addProductRow() {
    setState(() {
      _products.add(EditableProduct(
        productIdCtrl: TextEditingController(),
        quantityCtrl: TextEditingController(text: '1'),
      ));
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final updatedCart = CartModel(
      id: widget.cart.id,
      userId: int.parse(_userIdCtrl.text),
      date: _dateCtrl.text.trim(),
      products: _products
          .map((p) => CartProductModel(
                productId: int.parse(p.productIdCtrl.text),
                quantity: int.parse(p.quantityCtrl.text),
              ))
          .toList(),
    );
    context.read<CartCubit>().updateCart(widget.cart.id, updatedCart);
  }
}