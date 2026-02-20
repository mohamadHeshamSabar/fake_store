# ShopEase 🛍️
E-Commerce Flutter App with BLoC + Clean Architecture

## Architecture Overview

```
lib/
├── core/
│   ├── errors/          # Failures & Exceptions
│   ├── network/         # Dio HTTP client
│   ├── theme/           # App theme & colors
│   └── usecases/        # UseCase base class
├── features/
│   ├── products/
│   │   ├── data/        # Models, DataSources, Repository Impl
│   │   ├── domain/      # Entities, Repository Interface, UseCases
│   │   └── presentation/# BLoC, Pages, Widgets
│   ├── cart/
│   │   ├── domain/      # CartItem entity
│   │   └── presentation/# CartBloc, CartPage, Widgets
│   └── add_product/
│       └── presentation/# AddProductBloc, AddProductPage
├── injection_container.dart  # GetIt DI setup
└── main.dart
```

## Features
- 🏠 **Home Page** — Product grid with category filter chips & search
- 📦 **Product Detail** — Hero animation, full details, add-to-cart
- 🛒 **Cart** — Quantity controls, totals, checkout confirmation
- ➕ **Add Product** — Form with validation, posts to FakeStore API

## Setup

```bash
flutter pub get
flutter run
```

## Dependencies
| Package | Purpose |
|---|---|
| `flutter_bloc` | State management |
| `dio` | HTTP client |
| `get_it` | Dependency injection |
| `equatable` | Value equality |
| `dartz` | Functional Either type |
| `cached_network_image` | Image caching |
| `shimmer` | Loading skeletons |
| `badges` | Cart badge counter |

## API
All data comes from [FakeStoreAPI](https://fakestoreapi.com/docs)
# fake_store
