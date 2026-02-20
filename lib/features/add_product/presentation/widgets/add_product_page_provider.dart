import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/core/widgets/app_form_field.dart';
import 'package:ecommerce_app/core/widgets/section_label.dart';
import 'package:ecommerce_app/features/add_product/presentation/cubit/add_product_cubit.dart';
import 'package:ecommerce_app/features/add_product/presentation/cubit/add_product_state.dart';
import 'package:ecommerce_app/features/add_product/presentation/widgets/category_selector.dart';
import 'package:ecommerce_app/features/add_product/presentation/widgets/submit_button.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductPageProvider extends StatefulWidget {
  const AddProductPageProvider({super.key});

  @override
  State<AddProductPageProvider> createState() => _AddProductPageProviderState();
}

class _AddProductPageProviderState extends State<AddProductPageProvider> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  String _selectedCategory = 'electronics';

  static const _categories = [
    'electronics',
    'jewelery',
    "men's clothing",
    "women's clothing",
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state is AddProductSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Product added successfully!'),
              ]),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(12),
            ),
          );
          Navigator.pop(context);
        }
        if (state is AddProductFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('Add Product'),
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
                const SectionLabel('Product Details'),
                const SizedBox(height: 12),
                AppFormField(
                  controller: _titleCtrl,
                  label: 'Product Title',
                  hint: 'Enter product title',
                  icon: Icons.shopping_bag_outlined,
                  validator: (v) =>
                      v?.isEmpty == true ? 'Title is required' : null,
                ),
                const SizedBox(height: 14),
                AppFormField(
                  controller: _priceCtrl,
                  label: 'Price (\$)',
                  hint: '0.00',
                  icon: Icons.attach_money,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v?.isEmpty == true) return 'Price is required';
                    if (double.tryParse(v!) == null) return 'Invalid price';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AppFormField(
                  controller: _descCtrl,
                  label: 'Description',
                  hint: 'Describe your product...',
                  icon: Icons.description_outlined,
                  maxLines: 4,
                  validator: (v) =>
                      v?.isEmpty == true ? 'Description is required' : null,
                ),
                const SizedBox(height: 14),
                AppFormField(
                  controller: _imageCtrl,
                  label: 'Image URL',
                  hint: 'https://example.com/image.jpg',
                  icon: Icons.image_outlined,
                  validator: (v) =>
                      v?.isEmpty == true ? 'Image URL is required' : null,
                ),
                const SizedBox(height: 20),
                const SectionLabel('Category'),
                const SizedBox(height: 12),
                CategorySelector(
                  categories: _categories,
                  selected: _selectedCategory,
                  onChanged: (cat) => setState(() => _selectedCategory = cat),
                ),
                const SizedBox(height: 32),
                SubmitButton(
                  onSubmit: () {
                    if (!_formKey.currentState!.validate()) return;
                    final product = Product(
                      id: 0,
                      title: _titleCtrl.text.trim(),
                      price: double.parse(_priceCtrl.text),
                      description: _descCtrl.text.trim(),
                      category: _selectedCategory,
                      image: _imageCtrl.text.trim(),
                      rating: const Rating(rate: 0, count: 0),
                    );
                    context.read<AddProductCubit>().addProduct(product);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
