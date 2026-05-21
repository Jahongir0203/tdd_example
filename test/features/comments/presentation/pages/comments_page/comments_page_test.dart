import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';
import 'package:tdd_example/features/comments/domain/repository/comments_repository.dart';
import 'package:tdd_example/features/comments/presentation/cubits/comments_cubit/comments_cubit.dart';
import 'package:tdd_example/features/comments/presentation/pages/comments_page/widgets/widgets.dart';

// ─── Mock ────────────────────────────────────────────────────────────────────

class MockCommentsRepository extends Mock implements CommentsRepository {}

// ─── Test data ───────────────────────────────────────────────────────────────

final tComment = CommentModel(
  id: 1,
  postId: 1,
  name: 'John Doe',
  email: 'john@example.com',
  body: 'Test body text',
);

final tComments = [
  tComment,
  tComment.copyWith(id: 2),
  tComment.copyWith(id: 3),
];

// ─── Helpers ─────────────────────────────────────────────────────────────────

void main() {
  late MockCommentsRepository mockRepository;

  // registerFallbackValue: mocktail any() matcher uchun type fallback kerak.
  // cacheDuration: Duration type bo'lgani uchun Duration.zero fallback qilamiz.
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    mockRepository = MockCommentsRepository();
  });

  // buildSubject: har bir testda bir xil widget tree yasaymiz.
  // BlocProvider ichida CommentsCubit yaratib, getComments() chaqiramiz —
  // xuddi real CommentsPage kabi.
  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CommentsCubit(mockRepository)..getComments(),
        child: Scaffold(body: WCommentsBody()),
      ),
    );
  }

  // ─── Utility: mock setup ────────────────────────────────────────────────

  // Pending future: loading holatini "freeze" qilish uchun.
  // completer.future hech qachon tugamaydi → Cubit loading state'da qoladi.
  Completer<Either<dynamic, List<CommentModel>>> pendingCompleter() {
    final completer = Completer<Either<dynamic, List<CommentModel>>>();
    when(
      () => mockRepository.getComments(
        cacheDuration: any(named: 'cacheDuration'),
      ),
    ).thenAnswer((_) => completer.future);
    return completer;
  }

  // Success mock: darhol Right(comments) qaytaradi.
  void mockSuccess(List<CommentModel> comments) {
    when(
      () => mockRepository.getComments(
        cacheDuration: any(named: 'cacheDuration'),
      ),
    ).thenAnswer((_) async => Right(comments));
  }

  // Error mock: darhol Left(failure) qaytaradi.
  void mockFailure(String message) {
    when(
      () => mockRepository.getComments(
        cacheDuration: any(named: 'cacheDuration'),
      ),
    ).thenAnswer((_) async => Left(message));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 1: Loading holati
  // ═══════════════════════════════════════════════════════════════════════════

  group('CommentsPage — loading holati', () {
    testWidgets("getComments loading bo'lsa Skeleton ko'rinishi kerak", (
      tester,
    ) async {
      // ARRANGE
      // Completer ishlatamiz: future hech qachon resolve bo'lmaydi →
      // Cubit loading state'da "qotib" qoladi.
      final completer = pendingCompleter();

      // ACT
      await tester.pumpWidget(buildSubject());

      // pump(Duration.zero): bir frame render qilamiz.
      // pumpAndSettle() ishlatmaymiz — u barcha animatsiya/future tugashini
      // kutadi, loading holatini o'tkazib yuboradi.
      await tester.pump();

      // ASSERT
      expect(
        find.byType(WCommentSkeletonizerItem),
        findsWidgets, // kamida 1 ta bo'lsa kifoya
      );
      expect(find.byType(WCommentItem), findsNothing);

      // Cleanup: test leak bo'lmasin deb future'ni yopamiz.
      completer.complete(Right([]));
      await tester.pumpAndSettle();
    });

    testWidgets("loading paytda WCommentItem ko'rinmasligi kerak", (
      tester,
    ) async {
      final completer = pendingCompleter();

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(WCommentItem), findsNothing);

      completer.complete(Right([]));
      await tester.pumpAndSettle();
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 2: Success holati
  // ═══════════════════════════════════════════════════════════════════════════

  group("CommentsPage — success holati", () {
    testWidgets("getComments success bo'lsa comment list ko'rinishi kerak", (
      tester,
    ) async {
      // ARRANGE
      mockSuccess(tComments);

      // ACT
      await tester.pumpWidget(buildSubject());

      // pumpAndSettle: barcha async operatsiyalar (future, animation)
      // tugaguncha kutadi. Success state uchun ishlatamiz.
      await tester.pumpAndSettle();

      // ASSERT
      // tComments.length ta WCommentItem bo'lishi kerak
      expect(find.byType(WCommentItem), findsNWidgets(tComments.length));
      expect(find.byType(WCommentSkeletonizerItem), findsNothing);
    });

    testWidgets("comment contentlari to'g'ri ko'rinishi kerak", (tester) async {
      // ARRANGE
      mockSuccess([tComment]);

      // ACT
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // ASSERT: comment ma'lumotlari UI da ko'rinishi kerak
      expect(find.text(tComment.name), findsOneWidget);
      expect(find.text(tComment.email), findsOneWidget);
      expect(find.text(tComment.body), findsOneWidget);
    });

    testWidgets(
      "comments bo'sh list bo'lsa 'No comments yet' ko'rinishi kerak",
      (tester) async {
        // ARRANGE
        mockSuccess([]); // Empty list

        // ACT
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        // ASSERT
        expect(find.text('No comments yet'), findsOneWidget);
        expect(find.byType(WCommentItem), findsNothing);
      },
    );
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 3: Error holati
  // ═══════════════════════════════════════════════════════════════════════════

  group("CommentsPage — error holati", () {
    testWidgets("getComments fail bo'lsa error icon ko'rinishi kerak", (
      tester,
    ) async {
      // ARRANGE
      mockFailure('Server xatosi');

      // ACT
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // ASSERT
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.byType(WCommentItem), findsNothing);
      expect(find.byType(WCommentSkeletonizerItem), findsNothing);
    });

    testWidgets("error message to'g'ri ko'rinishi kerak", (tester) async {
      // ARRANGE
      const errorMessage = 'Server xatosi';
      mockFailure(errorMessage);

      // ACT
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // ASSERT
      expect(find.text(errorMessage), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 4: Refresh holati
  // ═══════════════════════════════════════════════════════════════════════════
  group("CommentsPage - refresh holati", () {
    testWidgets(
      "pull-to-refresh qilinsa getComments qayta chaqirilishi kerak",
      (tester) async {
        // ARRANGE
        when(
          () => mockRepository.clear(),
        ).thenAnswer((_) async {}); // ← QO'SHING
        mockSuccess(tComments);

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        // ACT
        final cubit = tester
            .element(find.byType(WCommentsBody))
            .read<CommentsCubit>();
        await cubit.refresh();
        await tester.pumpAndSettle();

        // ASSERT
        verify(
          () => mockRepository.getComments(
            cacheDuration: any(named: 'cacheDuration'),
          ),
        ).called(2);
      },
    );
  });
}
