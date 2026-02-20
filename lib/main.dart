import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/products/presentation/cubit/products_cubit.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/products/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ProductsCubit: auto-loads products on app start
        BlocProvider(
          create: (_) => di.sl<ProductsCubit>()..getAllProducts(),
        ),
        // CartCubit: global so cart badge stays in sync across pages
        BlocProvider(create: (_) => di.sl<CartCubit>()),
      ],
      child: MaterialApp(
        title: 'ShopEase',
        theme: AppTheme.lightTheme,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
