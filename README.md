# 📱 TDD Example — Flutter Comments App

A Flutter project demonstrating **Clean Architecture**, **BLoC/Cubit** state management, and a complete **TDD (Test-Driven Development)** test suite.

---

## 🗂️ Project Structure

```
lib/
├── core/                         # App-wide shared infrastructure
│   ├── constants/                # App-level constants (base URLs, keys, etc.)
│   ├── di/                       # Dependency injection (injectable + get_it)
│   ├── helpers/                  # Reusable utilities (toast, error handler, enums)
│   ├── network/                  # Dio client, interceptors (log, connection check)
│   ├── router/                   # Auto-route navigation setup
│   ├── theme/                    # Colors, text styles, theme config
│   └── utils/                    # Misc utility functions
│
└── features/
    └── comments/                 # Comments feature (self-contained module)
        ├── data/
        │   ├── datasource/       # Remote data source (Dio-based API calls)
        │   ├── models/           # Freezed data models + JSON serialization
        │   └── repository/       # Repository implementation (data layer)
        ├── domain/
        │   └── repository/       # Abstract repository interface (contract)
        └── presentation/
            ├── cubits/           # BLoC/Cubit state management
            └── pages/            # UI screens + widgets
```

---

## 🏛️ Clean Architecture — Qisqacha

Clean Architecture loyihani **3 qatlamga** ajratadi. Har bir qatlam faqat pastki qatlamga bog'liq bo'ladi, hech qachon aksincha emas.

```
┌─────────────────────────────┐
│      Presentation Layer      │  ← UI, Cubit, BLoC
├─────────────────────────────┤
│        Domain Layer          │  ← Abstract Repository (interface only)
├─────────────────────────────┤
│         Data Layer           │  ← Datasource, Model, Repository Impl
└─────────────────────────────┘
```

### Nima uchun bu muhim?

| Qatlam | Vazifasi | Bu loyihada |
|---|---|---|
| **Data** | API, DB, cache bilan ishlaydi | `CommentsDatasourceImpl`, `CommentsRepositoryImpl` |
| **Domain** | Biznes qoidalari, abstractlar | `CommentsRepository` (interface) |
| **Presentation** | UI + state management | `CommentsCubit`, `CommentsPage`, widgets |

> **Asosiy qoida:** `CommentsCubit` faqat `CommentsRepository` *interface*ini biladi — `Impl`ni bilmaydi. Bu test yozishni va kodni almashtirini osonlashtiradi.

---

## 🧪 Test Suite

```
test/
└── features/
    └── comments/
        ├── data/
        │   ├── datasource/       → Unit: DioClient mock bilan API test
        │   ├── models/           → Unit: JSON parse va default qiymatlar
        │   └── repository/       → Unit: Repository delegatsiya testi
        └── presentation/
            ├── cubits/           → Unit: Cubit state transitions (blocTest)
            └── pages/            → Widget: UI holatlari (loading/success/error/refresh)
```

### Test piramidasi

```
        /\
       /  \   Widget Tests  ← UI render, user interaction
      /----\
     /      \ Unit Tests    ← Cubit, Repository, Datasource, Model
    /--------\
```

### Test turlari va misollar

**Unit Test — Model:**
```dart
test('fromJson - to\'g\'ri model yasaydi', () {
  final result = CommentModel.fromJson(tJson);
  expect(result, equals(tModel));
});
```

**Unit Test — Cubit (blocTest):**
```dart
blocTest<CommentsCubit, CommentsState>(
  'getComments-success: loading → success emit qilinadi',
  build: () { /* mock setup */ return cubit; },
  act: (cubit) => cubit.getComments(),
  expect: () => [
    isA<CommentsState>().having((s) => s.status, 'status', RequestStatus.loading),
    isA<CommentsState>().having((s) => s.status, 'status', RequestStatus.success),
  ],
);
```

**Widget Test — Loading holati:**
```dart
// Completer ishlatamiz: future hech qachon resolve bo'lmaydi
// → Cubit loading state'da "qotib" qoladi
// → pump() ishlatamiz, pumpAndSettle() EMAS
final completer = Completer<Either<dynamic, List<CommentModel>>>();
when(() => mockRepository.getComments(...)).thenAnswer((_) => completer.future);

await tester.pumpWidget(buildSubject());
await tester.pump(); // ← bitta frame, settle emas!

expect(find.byType(WCommentSkeletonizerItem), findsWidgets);
```

---

## 📦 Asosiy Packagelar

| Package | Maqsadi |
|---|---|
| `flutter_bloc` | State management |
| `freezed` | Immutable models va union types |
| `injectable` + `get_it` | Dependency injection |
| `dio` + `dio_cache_interceptor` | HTTP client + caching |
| `auto_route` | Navigation |
| `dartz` | Functional error handling (`Either`) |
| `skeletonizer` | Loading skeleton UI |
| `mocktail` | Mock objects for testing |
| `bloc_test` | BLoC/Cubit unit testing |

---

## 🚀 Ishga Tushirish

```bash
# Dependencies o'rnatish
flutter pub get

# Code generation (freezed, injectable, auto_route)
dart run build_runner build --delete-conflicting-outputs

# Barcha testlarni ishga tushirish
flutter test

# Muayyan test faylini ishga tushirish
flutter test test/features/comments/presentation/cubits/comments_cubit_test.dart
```

---

## 🔑 Keystore (Debug)

```
key_alias : tdd_example
password  : 123456
```

---

## 💡 Arxitektura Qarorlari

- **`Either<L, R>`** — exception throw qilish o'rniga, xatolar `Left`, muvaffaqiyat `Right` sifatida qaytariladi. Bu Cubit'da `result.fold(...)` bilan clean error handling imkonini beradi.
- **Cache + Refresh** — `DioClient` cache'ni boshqaradi. `refresh()` cache'ni tozalab, yangi so'rov yuboradi.
- **`buildWhen` / `listenWhen`** — `BlocConsumer`da keraksiz rebuild va listener chaqiruvlarining oldini oladi.
- **`Completer` in Widget Tests** — loading holatini "freeze" qilish uchun ishlatiladi, `pumpAndSettle()` buni o'tkazib yuborardi.