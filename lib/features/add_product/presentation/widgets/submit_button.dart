import 'package:ecommerce_app/features/add_product/presentation/cubit/add_product_cubit.dart';
import 'package:ecommerce_app/features/add_product/presentation/cubit/add_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitButton({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductCubit, AddProductState>(
      builder: (context, state) {
        final isLoading = state is AddProductLoading;
        return ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 54)),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              : const Text('Add to Store'),
        );
      },
    );
  }
}
