import 'package:ecommerce_app/features/add_product/presentation/widgets/add_product_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../cubit/add_product_cubit.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddProductCubit>(),
      child: AddProductPageProvider(),
    );
  }
}
