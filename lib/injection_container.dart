import 'package:get_it/get_it.dart';
import 'core/network/internet_service.dart';
import 'features/add_product/presentation/cubit/add_product_cubit.dart';
import 'features/cart/data/datasources/cart_remote_datasource.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/products/data/datasources/product_remote_datasource.dart';
import 'features/products/presentation/cubit/products_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─── Cubits ──────────────────────────────────────────────────────────────
  sl.registerFactory(() => ProductsCubit(sl()));
  sl.registerFactory(() => CartCubit(sl()));
  sl.registerFactory(() => AddProductCubit(sl()));

  // ─── Data Sources ─────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => ProductRemoteDataSource(sl()));
  sl.registerLazySingleton(() => CartRemoteDataSource(sl()));

  // ─── Network ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => InternetService());
}
