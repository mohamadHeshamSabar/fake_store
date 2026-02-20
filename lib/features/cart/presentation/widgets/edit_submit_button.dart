import 'package:ecommerce_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditSubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const EditSubmitButton({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final loading = state is CartLoading;
        return ElevatedButton(
          onPressed: loading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            backgroundColor: Colors.orange,
          ),
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'Update Cart',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
        );
      },
    );
  }
}
