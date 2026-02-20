class AppVariables {
  // ─── Base URL ───────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://fakestoreapi.com';

  // ─── Product endpoints ──────────────────────────────────────────────────────
  static const String productsEndpoint = '/products';
  static String productByIdEndpoint(int id) => '/products/$id';

  // ─── Cart endpoints ─────────────────────────────────────────────────────────
  static const String cartsEndpoint = '/carts';
  static String cartByIdEndpoint(int id) => '/carts/$id';
}
