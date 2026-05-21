# 📱 TDD Example — Flutter Comments App

A Flutter project demonstrating **Clean Architecture**, **BLoC/Cubit** state management, and a complete **TDD (Test-Driven Development)** test suite.

---

## 🗂️ Project Structure

```
lib/
├── core/                             # App-wide shared infrastructure
│   ├── constants/
│   │   └── app_const.dart            # BASE_URL, DEV_MODE (dart-define), timeout
│   ├── di/
│   │   ├── di.dart                   # GetIt instance + configureDependencies()
│   │   └── di_module.dart            # @module: CacheOptions, Alice, InternetConnection
│   ├── helpers/
│   │   ├── app_toast.dart            # Custom animated overlay toast (success/error/warning/info)
│   │   ├── enum_helpers.dart         # RequestStatus enum + extension (isLoading, isFail…)
│   │   └── error_handler.dart        # DioException → human-readable string, localized messages
│   ├── network/
│   │   ├── dio_client.dart           # Singleton Dio factory: cache, Alice, log interceptors
│   │   ├── connection_checker_interceptor.dart  # Rejects request if no internet
│   │   └── my_log_interceptor.dart   # Dev-only request/response logger (masks secrets)
│   ├── router/
│   │   ├── routes.dart               # AppRouter config (auto_route)
│   │   └── routes.gr.dart            # Generated route classes (do not edit)
│   ├── theme/
│   │   ├── app_colors.dart           # Sealed class — static color constants
│   │   ├── app_text_styles.dart      # Sealed class — static TextStyle constants
│   │   └── theme.dart                # AppTheme.light (ThemeData)
│   └── utils/                        # (reserved for future utilities)
│
└── features/
    └── comments/                     # Self-contained feature module
        ├── data/
        │   ├── datasource/
        │   │   └── comments_datasource.dart      # Interface + Impl (Dio GET /comments)
        │   ├── models/
        │   │   └── comment_model.dart            # Freezed model + fromJson
        │   └── repository/
        │       └── comments_repository_impl.dart # Delegates to datasource
        ├── domain/
        │   └── repository/
        │       └── comments_repository.dart      # Abstract interface (contract)
        └── presentation/
            ├── cubits/
            │   └── comments_cubit/
            │       ├── comments_cubit.dart       # getComments(), refresh()
            │       └── comments_state.dart       # Freezed state (status, comments, error)
            └── pages/
                └── comments_page/
                    ├── comments_page.dart        # BlocProvider + Scaffold
                    └── widgets/
                        ├── w_comments_body.dart      # BlocConsumer: loading/success/error UI
                        ├── w_comment_item.dart        # Single comment card (checkbox)
                        ├── w_comments_skeletonizer.dart  # Skeleton placeholder
                        └── widgets.dart              # Barrel export
```

---

## 🏛️ Clean Architecture

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

| Qatlam | Vazifasi | Bu loyihada |
|---|---|---|
| **Data** | API, DB, cache bilan ishlaydi | `CommentsDatasourceImpl`, `CommentsRepositoryImpl` |
| **Domain** | Biznes qoidalari, abstractlar | `CommentsRepository` (interface) |
| **Presentation** | UI + state management | `CommentsCubit`, `CommentsPage`, widgets |

> **Asosiy qoida:** `CommentsCubit` faqat `CommentsRepository` *interface*ini biladi — `Impl`ni bilmaydi. Bu test yozishni va implementatsiyani almashtirini osonlashtiradi.

---

## 🧪 Test Suite

```
test/
└── features/
    └── comments/
        ├── data/
        │   ├── datasource/   → Unit: DioClient mock bilan API test
        │   ├── models/       → Unit: JSON parse va default qiymatlar
        │   └── repository/   → Unit: Repository delegatsiya testi
        └── presentation/
            ├── cubits/       → Unit: Cubit state transitions (blocTest)
            └── pages/        → Widget: UI holatlari (loading/success/error/refresh)
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
| `dio_cache_interceptor_hive_store` | Hive-based persistent cache |
| `auto_route` | Navigation |
| `dartz` | Functional error handling (`Either`) |
| `alice` + `alice_dio` | Dev-only HTTP inspector |
| `internet_connection_checker_plus` | Internet connectivity check |
| `skeletonizer` | Loading skeleton UI |
| `mocktail` | Mock objects for testing |
| `bloc_test` | BLoC/Cubit unit testing |

---

## 🛠️ Makefile Commands

Makefile orqali barcha tez-tez ishlatiladigan commandlar bitta joyda:

```bash
make clean          # flutter clean + pub get
make gen            # build_runner watch (live codegen)
make gen-one        # build_runner build (bir martalik)
make gen-clean      # build_runner clean
make fix            # dart fix --apply + dart format
make fmt            # dart format only

make run-dev        # .env.dev.json bilan run
make run-prod       # .env.prod.json bilan run

make build-dev      # APK (dev, release, obfuscated)
make build-prod     # APK (prod, release, obfuscated)
make build-aab      # App Bundle (prod)
make build-ipa      # IPA (prod, iOS)

make add-android    # Android platform qo'shish
make add-ios        # iOS platform qo'shish
make add-web        # Web platform qo'shish

make res            # res_generator ishga tushirish
make tr             # translate (res_generator)
make print          # PACKAGE_NAME va ORG_NAME ni chiqaradi
```

> Environment o'zgaruvchilar `.env.dev.json` va `.env.prod.json` fayllarida saqlanadi va `--dart-define-from-file` orqali uzatiladi. `AppConst.baseUrl` va `AppConst.devMode` shundan o'qiladi.

---

## 🚀 Ishga Tushirish

```bash
# Dependencies o'rnatish
flutter pub get

# Code generation (freezed, injectable, auto_route)
make gen-one

# Dev rejimida ishga tushirish
make run-dev

# Barcha testlarni ishga tushirish
flutter test

# Muayyan test faylini ishga tushirish
flutter test test/features/comments/presentation/cubits/comments_cubit_test.dart
```

---

## 💡 Arxitektura Qarorlari

- **`Either<L, R>`** — exception throw qilish o'rniga, xatolar `Left`, muvaffaqiyat `Right` sifatida qaytariladi. Cubit'da `result.fold(...)` bilan clean error handling.
- **Cache + Refresh** — `DioClient` `cacheDuration` parametri asosida `DioCacheInterceptor` qo'shadi. `refresh()` cache'ni tozalab yangi so'rov yuboradi.
- **`ConnectionCheckerInterceptor`** — cache ishlatilmayotganda (duration = 0) internet yo'qligini erta aniqlaydi va `DioException` qaytaradi.
- **`buildWhen` / `listenWhen`** — `BlocConsumer`da keraksiz rebuild va listener chaqiruvlarining oldini oladi.
- **`Completer` in Widget Tests** — loading holatini "freeze" qilish uchun; `pumpAndSettle()` ishlatilsa loading state o'tkazib yuboriladi.
- **`sealed class` for theme** — `AppColors` va `AppTextStyles` instantiate qilib bo'lmaydi, faqat static access.
- **`dart-define-from-file`** — environment config kodni ichiga hardcode qilinmaydi, `.env.*.json` fayllardan o'qiladi.
